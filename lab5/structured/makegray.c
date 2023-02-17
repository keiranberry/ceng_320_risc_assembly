#include <stdlib.h>
#include <stdio.h>
#include <netpbm.h>


static void usage(char *name)
{
  fprintf(stderr,"Usage: %s infile outfile\n",name);
  fprintf(stderr,"infile and outfile cannot be the same file.\n");
  exit(3);
}

int main(int argc, char **argv)
{
  rgbimage *color;
  grayimage *gray;
  
  if(argc!=3)
    usage(argv[0]);
  if(!strcmp(argv[1],argv[2]))
    usage(argv[0]);

  color=read_color_image(argv[1]);
  gray=color_to_gray(color);
  write_grayscale_image(argv[2],gray);

  return 0;
}
