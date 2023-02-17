#ifndef NETPBM_H
#define NETPBM_H

/* Define a color (RGB) pixel */
typedef struct{
  unsigned char red, green, blue;
}rgbpixel;

/* An image is made of rows of pixels */
typedef struct{
  rgbpixel **rows; /* pointer to array of pointers */
  int width;       /* number of columns (length of each row) */
  int height;      /* number of rows (length of array of pointers) */
}rgbimage;

/* Define a grayscale pixel (256 shades of gray) */
typedef unsigned char graypixel;

/* An image is made of rows of pixels */
typedef struct{
  graypixel **rows; /* pointer to array of pointers */
  int width;        /* number of columns (length of each row) */
  int height;       /* number of rows (length of array of pointers) */
}grayimage;

/* read_color_image will open a file and read a Netppm image */
rgbimage *read_color_image(char *filename);

/* write_grayscale_image will open a file and write a Netpgm image */
void write_grayscale_image(char *filename, grayimage *image);

/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image. */
grayimage *color_to_gray(rgbimage *image);

/* allocate_grayimage is a utility function for creating the data
   structure to hold a grayscale image */
grayimage *allocate_grayimage(int width, int height);

/* allocate_rgbimage is a utility function for creating the data
   structure to hold a color (rgb) image */
rgbimage *allocate_rgbimage(int width, int height);

#endif
