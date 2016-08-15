clear all
close all
clc

number=6;  %number of data set
file = './data/Repeat1.txt';
%load in data set
concentration=[0,0,0.1,0.5,1,5];
S=load(file);
OD_time=S(:,1);
for i=1:number
    OD(:,i)=S(:,i+1)
end

%calculate speed
for j = 1:number
    for i= 1:(length(OD_time)-1)
    Speed_time(i)=OD_time(i+1);
    Speed(i,j)=OD(i+1,j)-OD(i,j);
    end
end

%Run average every 50
for k = 1:number
   for i= 1:(length(Speed_time)-50)
    avg_time(i)=Speed_time(i);
    sum=0;
    for j=0:(50-1)
        sum=sum+Speed(i+j,k);
    end
    avg(i,k)=sum/50;
    end
end

% clear sum to avoid overloading built-in function
clear sum


%split it AND plot
for k=1:number
    subplot(2,number/2,k);
    plot(avg_time,avg(:,k));
    xlabel('time(mins)');
    ylabel('speed');
    title(concentration(k));
end