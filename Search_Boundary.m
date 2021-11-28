function [border,sub_border,NaNs,NaNE]=Search_Boundary(data,t)
%%
n=size(data,1);
Degree_border=zeros(n,1); % the border degree of each sample
%% £¨1£©NaN_Search
[NaNs,NaNE]=NaN_Search(data);
%% Compute Border_Degree and Search for boderline samples
border=[];
for i=1:n
    self_label=t(i);
    Labels_NaNs=t(NaNs{i});
    pos=find(Labels_NaNs~=self_label);
    Degree_border(i)=length(pos); % compute Border_Degree
    % Search for boderline samples
    if ~isempty(pos)
        border=[border;i];
    end
end
%% 
S=[];
[~,index]=sort(Degree_border(border),'descend');
for i=1:length(border)
    %% 
    idx=index(i);
    self_label=t(border(idx));
    %% 
    pos=intersect(S,NaNs{border(idx)});
    labels=t(pos);
    len=length(find(labels==self_label));
    if  len==0
        S=[S;border(idx)];
    end
end
sub_border=S;
end

