#include <stdlib.h>
#include <stdio.h>
#include <netpbm.h>

static void scream_and_die(char *msg)
{
  perror(msg);
  exit(1);
}

/* read_color_image will open a file and read a Netppm image */
rgbimage *read_color_image(char *filename)
{
  FILE *infile;
  char magic[2];
  rgbimage *image;
  int width,height,maxval;
  int i,j,tmpr,tmpg,tmpb;
  if((infile = fopen(filename,"r"))==NULL)
    scream_and_die("read_color_image");
  if(fread(magic,1,2,infile) != 2)
    scream_and_die("read_color_image");
  if((magic[0] != 'P')||((magic[1]!='3')&&(magic[1]!='6')))
    {
      fprintf(stderr,"read_color_image: Not a portable pixmap file.\n");
      exit(2);
    }
  if(fscanf(infile,"%d%d%d",&width,&height,&maxval)!=3)
    scream_and_die("read_color_image");
  if(maxval>255)
    {
      fprintf(stderr,"read_color_image: Too many bits per pixel.\n");
      exit(2);
    }
  image=allocate_rgbimage(width,height);
  if(magic[1]=='6')
    { /* Binary format */
      for(i=0;i<height;i++)
	if(fread(image->rows[i],sizeof(rgbpixel),width,infile)!=width)
	  scream_and_die("read_color_image");
    }
  else
    { /* ASCII format */
      for(i=0;i<height;i++)
	for(j=0;i<width;j++)
	  {
	    if(fscanf(infile,"%d%d%d",&tmpr,&tmpg,&tmpb) !=1 )
	      scream_and_die("read_color_image");
	    image->rows[i][j].red=tmpr;
	    image->rows[i][j].green=tmpg;
	    image->rows[i][j].blue=tmpb; 
	  }
    }
  fclose(infile);
  return image;
}
      
/* write_grayscale_image will open a file and write a Netpgm image */
void write_grayscale_image(char *filename, grayimage *image)
{
  FILE *outfile;
  int i,j;
  if((outfile = fopen(filename,"w"))==NULL)
    scream_and_die("write_grayscale_image");
  /* we will write an ASCII grayscale image */
  if(fprintf(outfile,"P2\n%d\n%d\n255\n",image->width,image->height)<0)
    scream_and_die("write_grayscale_image");
  for(i=0;i<image->height;i++)
    {
      for(j=0;j<image->width;j++)
     	if(fprintf(outfile,"%d ",image->rows[i][j])<0)
	  scream_and_die("write_grayscale_image");
      fprintf(outfile,"\n");
    }
  fclose(outfile);
}


/* allocate_grayimage is a utility function for creating the data
   structure to hold a grayscale image */
grayimage *allocate_grayimage(int width, int height)
{
  grayimage *image;
  int i;
  if((image = (grayimage*)malloc(sizeof(grayimage)))==NULL)
    scream_and_die("allocate_grayimage");
  image->width = width;
  image->height = height;
  if((image->rows=(graypixel**)malloc(height*sizeof(graypixel*)))==NULL)
    scream_and_die("allocate_grayimage");
  for(i=0;i<height;i++)
    if((image->rows[i]=(graypixel*)malloc(width*sizeof(graypixel)))==NULL)
      scream_and_die("allocate_grayimage");
  return image;
}

/* allocate_rgbimage is a utility function for creating the data
   structure to hold a color (rgb) image */
rgbimage *allocate_rgbimage(int width, int height)
{
  rgbimage *image;
  int i;
  if((image = (rgbimage*)malloc(sizeof(rgbimage)))==NULL)
    scream_and_die("allocate_rgbimage");
  image->width = width;
  image->height = height;
  if((image->rows=(rgbpixel**)malloc(height*sizeof(rgbpixel*)))==NULL)
    scream_and_die("allocate_rgbimage");
  for(i=0;i<height;i++)
    if((image->rows[i]=(rgbpixel*)malloc(width*sizeof(rgbpixel)))==NULL)
      scream_and_die("allocate_rgbimage");
  return image;
}


