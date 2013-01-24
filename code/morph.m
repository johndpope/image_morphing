function morphed_im=morph(im1,im2,im1_pts,im2_pts,tri,warp_frac,dissolve_frac)
    sz=[max(size(im1,1),size(im2,1)) max(size(im1,2),size(im2,2)) 3];
    mean_pts=(1-warp_frac)*im1_pts+(warp_frac)*im2_pts;
    %morphed_im=imresize(im1,[size(im1,1) size(im1,2)]);
    imwarp1=imwarpv(im1,im1_pts,mean_pts,sz);
    imwarp2=imwarpv(im2,im2_pts,mean_pts,sz);
    morphed_im=(1-dissolve_frac)*imwarp1+(dissolve_frac)*imwarp2;
    %figure,imagesc(uint8(morphed_im));
end