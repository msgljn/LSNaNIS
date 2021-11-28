function [Subdata,Subt]=LSNaNIS(data,t)
%% (1) LS_search
[NaNs,NaNE]=NaN_Search(data);
%% (2) LSEdit
[data,t,subx]=NaNs_edit(data,t,NaNs);
%% (3) LSBorder
[border,sub_border,NaNs,NaNE]=Search_Boundary(data,t);
%% (4) LSCore
[core,coret]= Internal_Selection( data,t,border,NaNs,NaNE );
%% （5）
SubX=border;
SubX=unique(SubX);
Subdata=data(SubX,:);
Subdata=[Subdata;core];
Subt=t(SubX);
Subt=[Subt;coret];
end

