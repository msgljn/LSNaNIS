function [core,coret]= Internal_Selection( data,t,border,NaNs,NaNE )
%% initial parameters
n=length(t);
%% Nb：LSC
for i=1:n
    Nb(i)=length(NaNs{i})+1;
end
%% 从最大的LSC开始
[value,index]=sort(Nb,'descend');
%% 初始簇的变量
cluster=zeros(n,1); % cluster: 记录了每个样本所属簇的簇标号
cluster_number=0; % cluster_number:记录了簇的数量
%% 运行聚类算法和选择代表点算法
for i=1:n
    % 取出LSC较大的样本
    idx=index(i);
    % 记录它的自然近邻序号
    NNs=NaNs{idx};
    % 记录它的自然近邻的标签
    NNs_label=t(NNs);
    % 看取出的样本是否是边界样本，即，只对非边界样本进行聚类
    tpos=intersect(idx,border);
    if cluster_number==0 
        cluster_number=cluster_number+1;
        if length(tpos)==0 % 如果是内部样本
            self_label=t(idx);
            cluster(idx)=cluster_number;
            % condition1: NaNs是同一类的加入到 聚类中
            tpos=find(NNs_label==self_label);
            choosNN=NNs(tpos);
            % condition2: 排除边界样本
            choosNN=setdiff(choosNN,border);
            % 把是同一类且不是边界样本的idx的自然近邻形成初始的聚类，聚类的标号为：1
            cluster(choosNN)=cluster_number;
        end
    else % 如果已经有聚类了
        if cluster(idx)~=0  % 如果idx已经被分配了，continue,下一次循环，看下密度相对大的样本
            continue;
        else
            %如果idx不在已有的聚类中，idx为一个新的簇或者聚类开始扩散
            cluster_number=cluster_number+1;
            self_label=t(idx);
            cluster(idx)=cluster_number;
            % condition1: NaNs是同一类的加入到 聚类中
            tpos=find(NNs_label==self_label);
            choosNN=NNs(tpos);
            % condition2: 排除边界样本
            choosNN=setdiff(choosNN,border);
            % condition3: 把未分配的样本形成聚类
            haveClusterpos=find(cluster~=0);
            choosNN=setdiff(choosNN,haveClusterpos);
            cluster(choosNN)=cluster_number;
        end
    end
    
%% 迭代扩大簇的范围和合并簇
    % 取出没有聚类的样本
    pos2=find(cluster==0);
    count=1;
    %cluster_number
    % record 记录每次迭代还没有聚类的样本，如果前后两次迭代没有变，那么停止聚类。
    record=[];
    record(count)=length(pos2);
    while 1
        for j=1:length(pos2)
            % 没有聚类样本在data中的序号,随机选出
            id=pos2(j);
            id_label=t(id);
            NNs=NaNs{id};
            NNs_label=t(NNs);
            % 如果没有聚类的样本和idx形成的初始聚类的样本有交集,当前idx(类标号:cluster_number)
            tpos=find(cluster(NNs)==cluster_number);
            if length(tpos)>=(length(NNs)+1)/2 %合并条件1
                if id_label==self_label %合并条件2
                    cluster(id)=cluster_number;
                    % condition 1: 同一类
                    tpos=find(NNs_label==self_label);
                    choosNN=NNs(tpos);
                    % condition 2: 排除边界样本
                    choosNN=setdiff(choosNN,border); 
                    % condition 3: 如果没有分配
                    haveClusterpos=find(cluster~=0);
                    choosNN=setdiff(choosNN,haveClusterpos);
                    cluster(choosNN)=cluster_number;
                end
            end
        end
        count=count+1;
        pos2=find(cluster==0);
        record(count)=length(pos2);
        if count>1
            if record(count)==record(count-1)
                break;
            end
        end
    end
end
%% 选取每个簇的代表点
core=[];
coret=[];
for i=0:length(unique(cluster))
    if i~=0
        pos=find(cluster==i);
        if length(pos)>NaNE           
            core=[core;mean(data(pos,:))];
            coret=[coret;unique(t(pos))];
        end
    end
end
%%
end

