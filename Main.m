
clear all
close all
clc

%��i10�����
number=10;
%�ƾڪ��ɶ����j�O�T����
t=3;
%�o���ɦW�令 ''�{�b�ɶ�/�Τ�m�W''
outputName='result.txt';
file = '/Users/chenshuyu/Desktop/Find Parameter/0822exp/D.csv';
%load in data set
S=load(file);


OD_time=S(:,1);
%���l�å�Ū�ȿ�J
for i=1:number
    OD(:,i)=S(:,i+1)
end

%calculate speed
%���۴�p��ɶ��ܤƲv
for j = 1:number
    for i= 1:(length(OD_time)-1)
    Speed_time(i)=OD_time(i+1);
    Speed(i,j)=OD(i+1,j)-OD(i,j);
    end
end



%Run average every 25
for k = 1:number
   for i= 1:(length(Speed_time)-25)
    avg_time(i)=Speed_time(i);
    sum=0;
    for j=0:(25-1)
        sum=sum+Speed(i+j,k);
    end
    avg(i,k)=sum/25;
    end
end
%Large counting number
l=0;
%R counting number
m=1;
%��Q������Ȱ����R�H�εe��
for k=1:number
    for i=1:length(avg_time);
        if avg(i,k)==max(avg(:,k));
            t0(k)=avg_time(i);
        end
    end
    Vmax=max(avg(:,k))/3;
    Vmax_k(k)=Vmax;
    %�o�ӧP�w�Ȧ��i��|��
    if Vmax >= 4.6
        l=l+1;
        x=-1;
    else
    %�o�Ө禡���i��|��
    x=(18.6542*Vmax-38.2493)/(5.07-Vmax);
    end
    if x<=0

        continue;
    else
        R(m)=x^(1/2.0183);
        m=m+1;
    end

end

if m<=number/2
    if l>number/2
        statement='The concentration is too high!!'
    else
        statement='The concentration is lower than 0.1'
    end

else
    %�o�Ӫ���Ϥ����D�ण��b�ѤW���e�X��
    hist(R);
   M=mean(R);
   S=std(R)
   %�����D������L�]�X��
    statement=['The mean value is ' ,M,'Standard deviation is',S]
end
%Use print(statement) here
statement;
