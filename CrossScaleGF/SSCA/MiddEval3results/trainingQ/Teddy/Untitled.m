clc;
clear all;
close all;

dispL = double(imread('disp0CSGF.png'))*4;

imwrite(uint8(dispL),['cones2','.png']);






