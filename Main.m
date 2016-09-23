
clear all
close all
clc

%輸進10筆資料
number=10;
%數據的時間間隔是三分鐘
t=3;
%這邊檔名改成 ''現在時間/用戶姓名''
outputName='result.txt';
file = '/Users/chenshuyu/Desktop/Find Parameter/0822exp/D.csv';
%load in data set
S=load(file);


OD_time=S(:,1);
%把原始螢光讀值輸入
for i=1:number
    OD(:,i)=S(:,i+1)
end

%calculate speed
%兩兩相減計算時間變化率
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
%對十次實驗值做分析以及畫圖
for k=1:number
    for i=1:length(avg_time);
        if avg(i,k)==max(avg(:,k));
            t0(k)=avg_time(i);
        end
    end
    Vmax=max(avg(:,k))/3;
    Vmax_k(k)=Vmax;
    %這個判定值有可能會改
    if Vmax >= 4.6
        l=l+1;
        x=-1;
    else
    %這個函式有可能會改
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
    %這個直方圖不知道能不能在Ｃ上面畫出來
    hist(R);
   M=mean(R);
   S=std(R)
   %不知道怎麼讓他跑出來
    statement=['The mean value is ' ,M,'Standard deviation is',S]
end
%Use print(statement) here
statement;
