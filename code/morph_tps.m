function morphed_im= morph_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts,sz)
    %im_source1=imresize(im_source,sz);
    im_source1=im_source;
    morphed_im=double(zeros([sz 3]));
    %imagesc(morphed_im);
    %morphed_im=im_source1;
    [imszY imszX imzx]=size(im_source1);
    Xarr1=repmat([1:imszX],1,imszY);
    %szXarr1=size(Xarr1)
    Xarr=repmat(Xarr1,size(ctr_pts,1),1);
    %szXarr=size(Xarr)
    Yarr1=reshape(repmat([1:imszY],imszX,1),[1 imszX*imszY]);
    %szYarr1=size(Yarr1)
    Yarr=repmat(Yarr1,size(ctr_pts,1),1);
    %szYarr=size(Yarr)
    carrX=repmat(ctr_pts(:,1),1,size(Xarr,2));
    carrY=repmat(ctr_pts(:,2),1,size(Yarr,2));
    diffX=carrX-Xarr;
    diffY=carrY-Yarr;
    U=((diffX.*diffX)+(diffY.*diffY));
    tmp=(U~=0);
    U=-1*U.*log(U);
    U(tmp==0)=0;
    %szU=size(U)
    %szw_x=size(w_x)
    %size(transpose(w_x)*U)
    %size(ax_x*Xarr1)
    if (size(w_x,1)==1) 
        w_x=transpose(w_x);
    end
    if (size(w_y,1)==1)
        w_y=transpose(w_y);
    end        
    fx=a1_x + ax_x*Xarr1 + ay_x*Yarr1 + transpose(w_x)*U; 
    fy=a1_y + ax_y*Xarr1 + ay_y*Yarr1 + transpose(w_y)*U;
    
    %fx=round(fx);
    %fy=round(fy);
    
    fxC=ceil(fx);
    fxF=floor(fx);
    fyC=ceil(fy);
    fyF=floor(fy);
    wtX=fx-fxF;
    wtY=fy-fyF;
    %sum(fx>imszX)
    %sum(fy>imszY)
    fxF(fxF<=0) =1;
    fyF(fyF<=0)=1;
    fxF(fxF>imszX)=imszX;
    fyF(fyF>imszY)=imszY;
    fxC(fxC<=0) =1;
    fyC(fyC<=0)=1;
    fxC(fxC>imszX)=imszX;
    fyC(fyC>imszY)=imszY;
    
    %fx(fx<=0) =1;
    %fy(fy<=0)=1;
    %fx(fx>imszX)=imszX;
    %fy(fy>imszY)=imszY;
    
    %sum(fx<=0 & fx>imszX)
    %sum(fy<=0 & fy>imszY)
    %size(fx)
    %size(fy)
    for i=1:size(fx,2)
        %gY=Yarr1(1,i)
        %gX=Xarr1(1,i)
        %fY=sum(fy>imszY)
        %fX=sum(fx>imszX)
        morphed_im(Yarr1(1,i),Xarr1(1,i),:)=(1-wtX(1,i))*(1-wtY(1,i))*im_source1(fyF(1,i),fxF(1,i),:) ...
              + (wtX(1,i))*(1-wtY(1,i))*im_source1(fyF(1,i),fxC(1,i),:) ...
              + (1-wtX(1,i))*(wtY(1,i))*im_source1(fyC(1,i),fxF(1,i),:) ...
              +(wtX(1,i))*(wtY(1,i))*im_source1(fyC(1,i),fxC(1,i),:);
       % morphed_im(Yarr1(1,i),Xarr1(1,i),:)= im_source1(fy(1,i),fx(1,i),:);
    end
    %morphed_im(1+(Yarr1-1)+(Xarr1-1)*size(im_source,1))=im_source(1+(fy-1)+(fx-1)*size(im_source,1));    
end