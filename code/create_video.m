function [frame]=create_video(name,im,im_pts,step)
    %function for creating video for tps
    fig=figure;
    aviobj=avifile(name,'fps',15);
    cnt=1;
    frame=zeros(size(im,1),size(im,2),size(im,3),(size(im,4)-1)*11);
    for i=2:size(im,4)
        for k=0:step:1
            z=wrapper_tps1(im(:,:,:,i-1),im(:,:,:,i),im_pts(:,:,i-1),im_pts(:,:,i),k,k);
            imagesc(uint8(z));
           % axis ([1 size(z,2)],[1 size(z,1)]);
            axis off;
            g=getframe(fig);
            aviobj=addframe(aviobj,g);
            frame(:,:,:,cnt)=z;
            cnt=cnt+1;
        end
    end
    aviobj=close(aviobj);
    clear aviobj;
end