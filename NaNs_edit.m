function [data,t,Noiise_index]=NaNs_edit(data,t,NaNs)
%%
n=size(data,1);
subX=[];
Noiise_index=[];
for i=1:n
    labels=[t(NaNs{i});t(i)];
    self_label=t(i);
    if length(NaNs{i})>0
        pos=find(labels~=self_label);
        NF=length(pos)/( length(NaNs{i})+1 );
        if NF<=0.5
            subX=[subX;i];
        else
            Noiise_index=[Noiise_index;i];
        end
    end
end
data=data(subX,:);
t=t(subX);
end

