
#import "UIImage+ImageEffects.h"
#import <Accelerate/Accelerate.h>


#define scaleDownFactor 1

@implementation UIImage (ImageEffects)

- (UIImage *)applyBlurWithCrop:(CGRect) bounds resize:(CGSize) size blurRadius:(CGFloat) blurRadius tintColor:(UIColor *) tintColor saturationDeltaFactor:(CGFloat) saturationDeltaFactor maskImage:(UIImage *) maskImage {

    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    
    if (!self.CGImage) {
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }

    //Crop
    UIImage *outputImage = nil;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    outputImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    //Re-Size
    CGImageRef sourceRef = [outputImage CGImage];
    NSUInteger sourceWidth = CGImageGetWidth(sourceRef);
    NSUInteger sourceHeight = CGImageGetHeight(sourceRef);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *sourceData = (unsigned char*) calloc(sourceHeight * sourceWidth * 4, sizeof(unsigned char));
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger sourceBytesPerRow = bytesPerPixel * sourceWidth;
    NSUInteger bitsPerComponent = 8;
    
    CGContextRef context = CGBitmapContextCreate(sourceData, sourceWidth, sourceHeight, bitsPerComponent, sourceBytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, sourceWidth, sourceHeight), sourceRef);
    CGContextRelease(context);
    
    NSUInteger destWidth = (NSUInteger) size.width / scaleDownFactor;
    NSUInteger destHeight = (NSUInteger) size.height / scaleDownFactor;
    NSUInteger destBytesPerRow = bytesPerPixel * destWidth;
    
    unsigned char *destData = (unsigned char*) calloc(destHeight * destWidth * 4, sizeof(unsigned char));
    
    vImage_Buffer src = {
        .data = sourceData,
        .height = sourceHeight,
        .width = sourceWidth,
        .rowBytes = sourceBytesPerRow
    };
    
    vImage_Buffer dest = {
        .data = destData,
        .height = destHeight,
        .width = destWidth,
        .rowBytes = destBytesPerRow
    };
    
    vImageScale_ARGB8888 (&src, &dest, NULL, kvImageNoInterpolation);
    
    free(sourceData);
    
    CGContextRef destContext = CGBitmapContextCreate(destData, destWidth, destHeight, bitsPerComponent, destBytesPerRow, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    
    CGImageRef destRef = CGBitmapContextCreateImage(destContext);
    
    outputImage = [UIImage imageWithCGImage:destRef];
    
    CGImageRelease(destRef);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(destContext);
    
    free(destData);
    
    //Blur
    CGRect imageRect = { CGPointZero, outputImage.size };
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    
    if (hasBlur || hasSaturationChange) {
    
        UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, 1);
        
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -outputImage.size.height);
        CGContextDrawImage(effectInContext, imageRect, outputImage.CGImage);

        vImage_Buffer effectInBuffer;
        
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
    
        UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, 1);
        
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

        if (hasBlur) {
            CGFloat inputRadius = blurRadius * 1;
            int radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            
            if (radius % 2 != 1) {
                radius += 1;
            }
            
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        
        BOOL effectImageBuffersAreSwapped = NO;
        
        if (hasSaturationChange) {
            
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                                  0,                    0,                    0,  1,
            };
            
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            } else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        
        if (!effectImageBuffersAreSwapped)
            outputImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();

        if (effectImageBuffersAreSwapped)
            outputImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
    }

    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, 1);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -outputImage.size.height);

    CGContextDrawImage(outputContext, imageRect, outputImage.CGImage);

    if (hasBlur && maskImage) {
        CGContextSaveGState(outputContext);
        CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        CGContextDrawImage(outputContext, imageRect, outputImage.CGImage);
        CGContextRestoreGState(outputContext);
    }

    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }

    outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return outputImage;
}

- (UIImage *)applyBlurWithBlurRadius:(CGFloat) blurRadius saturationDeltaFactor:(CGFloat) saturationDeltaFactor {
    return [self applyBlurWithCrop:(CGRect){CGPointZero, self.size}
                            resize:self.size
                        blurRadius:blurRadius
                         tintColor:[UIColor clearColor]
             saturationDeltaFactor:saturationDeltaFactor
                         maskImage:nil];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    if (CGRectEqualToRect(rect, CGRectZero)) {
        rect = CGRectMake(0, 0, 1, 1);
    }
    UIGraphicsBeginImageContext(rect.size);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage*)imageWithColor:(UIColor *)color roundSize:(CGFloat)roundCornerSize {
    CGSize imageSize = CGSizeMake(2 * roundCornerSize + 1, 2 * roundCornerSize + 1);
    UIImage *image = [UIImage imageWithColor:color size:imageSize];
    UIGraphicsBeginImageContextWithOptions((CGSize){imageSize.width, imageSize.height}, NO, 1);
    CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGPathRef p = CGPathCreateWithRoundedRect((CGRect){CGPointZero, imageSize}, roundCornerSize, roundCornerSize, NULL);
    CGContextAddPath(UIGraphicsGetCurrentContext(), p);
    CGContextClip(UIGraphicsGetCurrentContext());
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *decompressedImage = UIGraphicsGetImageFromCurrentImageContext();
    CGPathRelease(p);
    UIGraphicsEndImageContext();
    return decompressedImage;
}

- (void)decompress {
    CGImageRef imageRef = [self CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), 8, CGImageGetWidth(imageRef) * 4, colorSpace,kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    if (!context) { NSLog(@"Could not create context for image decompression"); return; }
    CGContextDrawImage(context, (CGRect){{0.0f, 0.0f}, {CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)}}, imageRef);
    CFRelease(context);

}

-(UIImage *)imageWithTintColor:(UIColor *)tintColor {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // draw alpha-mask
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, rect, self.CGImage);
    // draw tint color, preserving alpha values of original image
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImage;
}


- (UIImage *)imageWithHue:(float)hue {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter= [CIFilter filterWithName:@"CIHueAdjust"];
    CIImage *ciimg = [CIImage imageWithCGImage:self.CGImage];
    [filter setValue:ciimg forKey:kCIInputImageKey];
    [filter setValue:@(hue) forKey:@"inputAngle"];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg =[context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return img;
}


@end
