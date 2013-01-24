function warped_im=imwarpv(im,base_pts,new_pts,sz)
    %function for warping using triangulation
    %base_pts=[base_pts;[1 1];[size(im,2) 1]; [1 size(im,1)]; [size(im,2) size(im,1)]];
    %new_pts=[new_pts;[1 1];[size(im,2) 1]; [1 size(im,1)]; [size(im,2) size(im,1)]];
    dt=DelaunayTri(new_pts);
    %figure,triplot(dt);
    abc=ones(1,3,size(dt.Triangulation,1));
    tmpX=repmat(dt.X(:,1),[1 1 size(dt.Triangulation,1)]);
    tmpY=repmat(dt.X(:,2),[1 1 size(dt.Triangulation,1)]);
    ntri=reshape(transpose(dt.Triangulation),[1 3 size(dt.Triangulation,1)]);
    trimatwarp=[tmpX(ntri); tmpY(ntri); abc];
    
    tmpX=repmat(base_pts(:,1),[1 1 size(dt.Triangulation,1)]);
    tmpY=repmat(base_pts(:,2),[1 1 size(dt.Triangulation,1)]);
    ntri=reshape(transpose(dt.Triangulation),[1 3 size(dt.Triangulation,1)]);
    trimatim=[tmpX(ntri); tmpY(ntri); abc];
    %warped_im=double(zeros(sz));
    warped_im=imresize(im,[sz(1) sz(2)]);
    trimatwarp_inv=zeros(size(trimatwarp));
    for k=1:size(dt.Triangulation,1)
        trimatwarp_inv(:,:,k)=trimatwarp(:,:,k)^-1;
    end
    i=[1:size(warped_im,2)];
    j=[1:size(warped_im,1)];
    jarray=repmat(j,1,size(warped_im,2));
    iarray=reshape(repmat(i,size(warped_im,1),1),[1 size(warped_im,1)*size(warped_im,2)]);
    imarray=[iarray; jarray; ones(1,size(warped_im,1)*size(warped_im,2))];
    imarray=reshape(imarray,[size(imarray) 1]);
    for k=1:size(dt.Triangulation,1)
        bary=trimatwarp_inv(:,:,k)*imarray;
        baryn=bary(:,all(bary>0 & bary<1));
        imarrayn=imarray(:,all(bary>0 & bary<1));
        coord=trimatim(:,:,k)*baryn;
        %coordn=round(coord./repmat(coord(3,:),3,1));
        coordn=(coord./repmat(coord(3,:),3,1));
        coordF=floor(coordn);
        coordC=ceil(coordn);
        wt=(coordn-coordF);
        %coordn=(coordn<=0)+coordn;
        %limiting coordinates to image size
        coordF(coordF<=0)=1;
        coordC(coordC<=0)=1;
        tmp=coordF(1,:);
        tmp(tmp>size(im,2))=size(im,2);
        coordF(1,:)=tmp;
        tmp=coordC(1,:);
        tmp(tmp>size(im,2))=size(im,2);
        coordC(1,:)=tmp;
        tmp=coordF(2,:);
        tmp(tmp>size(im,1))=size(im,1);
        coordF(2,:)=tmp;
        tmp=coordC(2,:);
        tmp(tmp>size(im,1))=size(im,1);
        coordC(2,:)=tmp;
        %coordF(1,:)=coordF(1,:)-(coordF(1,:)>size(im,2));
        %coordC(1,:)=coordC(1,:)-(coordC(1,:)>size(im,2));
        %coordF(2,:)=coordF(2,:)-(coordF(2,:)>size(im,1));
        %coordC(2,:)=coordC(2,:)-(coordC(2,:)>size(im,1));
        %coordn(1,:)=coordn(1,:)-(coordn(1,:)>size(im,2));
        %coordn(2,:)=coordn(2,:)-(coordn(2,:)>size(im,1));
        for t=1:size(coordn,2)
            %warping by rounding off is commented
        %warped_im(imarrayn(2,t),imarrayn(1,t),:)=im(coordn(2,t),coordn(1,t),:); 
        %warping by interpolation
        warped_im(imarrayn(2,t),imarrayn(1,t),:)=(1-wt(2,t))*(1-wt(1,t))*im(coordF(2,t),coordF(1,t),:) ...
            + (wt(2,t))*(1-wt(1,t))*im(coordC(2,t),coordF(1,t),:) ...
            + (1-wt(2,t))*(wt(1,t))*im(coordF(2,t),coordC(1,t),:) ...
            + (wt(2,t))*(wt(1,t))*im(coordC(2,t),coordC(1,t),:);
            
        end
        %indim=sub2ind(im,repmat(coord(2,:),1,size(im,3)),repmat(coord(1,:),1,size(im,3)),reshape(repmat([1:size(im,3)],size(coord,2),1),[1 size(im,3)*size(coord,2)]));
        %indwarp=sub2ind(warped_im,repmat(imarrayn(2,:),1,size(im,3)),repmat(imarrayn(1,:),1,size(im,3)),reshape(repmat([1:size(im,3)],size(imarrayn,2),1),[1 size(im,3)*size(imarrayn,2)]));
        %warped_im(indwarp)=im(indim);
    end
    
    %figure,imagesc(uint8(warped_im));
end