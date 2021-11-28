function [core,coret]= Internal_Selection( data,t,border,NaNs,NaNE )
%% initial parameters
n=length(t);
%% Nb��LSC
for i=1:n
    Nb(i)=length(NaNs{i})+1;
end
%% ������LSC��ʼ
[value,index]=sort(Nb,'descend');
%% ��ʼ�صı���
cluster=zeros(n,1); % cluster: ��¼��ÿ�����������صĴر��
cluster_number=0; % cluster_number:��¼�˴ص�����
%% ���о����㷨��ѡ�������㷨
for i=1:n
    % ȡ��LSC�ϴ������
    idx=index(i);
    % ��¼������Ȼ�������
    NNs=NaNs{idx};
    % ��¼������Ȼ���ڵı�ǩ
    NNs_label=t(NNs);
    % ��ȡ���������Ƿ��Ǳ߽�����������ֻ�ԷǱ߽��������о���
    tpos=intersect(idx,border);
    if cluster_number==0 
        cluster_number=cluster_number+1;
        if length(tpos)==0 % ������ڲ�����
            self_label=t(idx);
            cluster(idx)=cluster_number;
            % condition1: NaNs��ͬһ��ļ��뵽 ������
            tpos=find(NNs_label==self_label);
            choosNN=NNs(tpos);
            % condition2: �ų��߽�����
            choosNN=setdiff(choosNN,border);
            % ����ͬһ���Ҳ��Ǳ߽�������idx����Ȼ�����γɳ�ʼ�ľ��࣬����ı��Ϊ��1
            cluster(choosNN)=cluster_number;
        end
    else % ����Ѿ��о�����
        if cluster(idx)~=0  % ���idx�Ѿ��������ˣ�continue,��һ��ѭ���������ܶ���Դ������
            continue;
        else
            %���idx�������еľ����У�idxΪһ���µĴػ��߾��࿪ʼ��ɢ
            cluster_number=cluster_number+1;
            self_label=t(idx);
            cluster(idx)=cluster_number;
            % condition1: NaNs��ͬһ��ļ��뵽 ������
            tpos=find(NNs_label==self_label);
            choosNN=NNs(tpos);
            % condition2: �ų��߽�����
            choosNN=setdiff(choosNN,border);
            % condition3: ��δ����������γɾ���
            haveClusterpos=find(cluster~=0);
            choosNN=setdiff(choosNN,haveClusterpos);
            cluster(choosNN)=cluster_number;
        end
    end
    
%% ��������صķ�Χ�ͺϲ���
    % ȡ��û�о��������
    pos2=find(cluster==0);
    count=1;
    %cluster_number
    % record ��¼ÿ�ε�����û�о�������������ǰ�����ε���û�б䣬��ôֹͣ���ࡣ
    record=[];
    record(count)=length(pos2);
    while 1
        for j=1:length(pos2)
            % û�о���������data�е����,���ѡ��
            id=pos2(j);
            id_label=t(id);
            NNs=NaNs{id};
            NNs_label=t(NNs);
            % ���û�о����������idx�γɵĳ�ʼ����������н���,��ǰidx(����:cluster_number)
            tpos=find(cluster(NNs)==cluster_number);
            if length(tpos)>=(length(NNs)+1)/2 %�ϲ�����1
                if id_label==self_label %�ϲ�����2
                    cluster(id)=cluster_number;
                    % condition 1: ͬһ��
                    tpos=find(NNs_label==self_label);
                    choosNN=NNs(tpos);
                    % condition 2: �ų��߽�����
                    choosNN=setdiff(choosNN,border); 
                    % condition 3: ���û�з���
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
%% ѡȡÿ���صĴ����
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

