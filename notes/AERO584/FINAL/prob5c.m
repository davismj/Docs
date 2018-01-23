close all
clear

%linS = {'-','--',':','-.'};
linS = {'-','--',':','-.','k-','r--','b:','g-.',':bs','--mo','-.r*'};

NN = length(linS);
ttg = linspace(0.1,10,NN);

for j = 1:NN
    n=0; 
    XNP=3.; 
    DISPLACE=200.; 
    THOM=ttg(j);   % modify
    VM=3000.; 
    VT=1000.; 
    RM1=0.; 
    RM2=1000.; 
    RT1=20000.; 
    RT2=1000.; 
    QSWITCH=0; 
    VT1=-VT; 
    VT2=0.; 
    T=0.; 
    S=0.; 
    RTM1=RT1-RM1;
    RTM2=RT2-RM2; 
    RTM=sqrt(RTM1^2+RTM2^2); 
    XLAM=atan2(RTM2,RTM1); 
    VM1=VM; 
    VM2=0.;
    VTM1=VT1-VM1; 
    VTM2=VT2-VM2; 
    VC=-(RTM1*VTM1+RTM2*VTM2)/RTM; 
    TGO=RTM/VC; 
    H=.005; 

    while VC>0.
        TGO=RTM/VC; 
        if(TGO>.3) 
            H=.00005; 
        end 

        if(TGO<=THOM && QSWITCH==0) 
            QSWITCH=1; 
            RT2=RT2+DISPLACE; 
        end 
        RT1OLD=RT1; 
        RT2OLD=RT2; 
        RM1OLD=RM1; 
        RM2OLD=RM2; 
        VM1OLD=VM1; 
        VM2OLD=VM2; 
        STEP=1;
        FLAG=0; 

        while STEP<=1 
            if FLAG==1 
                STEP=2; 
                RT1=RT1+H*VT1; 
                RT2=RT2+H*VT2; 
                RM1=RM1+H*VM1; 
                RM2=RM2+H*VM2; 
                VM1=VM1+H*AM1; 
                VM2=VM2+H*AM2; 
                T=T+H; 
            end 
            RTM1=RT1-RM1; 
            RTM2=RT2-RM2; 
            RTM=sqrt(RTM1^2+RTM2^2); 
            VTM1=VT1-VM1; 
            VTM2=VT2-VM2; 
            VC=-(RTM1*VTM1+RTM2*VTM2)/RTM; 
            XLAM=atan2(RTM2,RTM1); 
            XLAMD=(RTM1*VTM2-RTM2*VTM1)/(RTM*RTM); XNC=XNP*VC*XLAMD; 
            AM1=-XNC*sin(XLAM); 
            AM2=XNC*cos(XLAM); 
            FLAG=1; 
        end

        FLAG=0; 
        RT1=.5*(RT1OLD+RT1+H*VT1); 
        RT2=.5*(RT2OLD+RT2+H*VT2); 
        RM1=.5*(RM1OLD+RM1+H*VM1); 
        RM2=.5*(RM2OLD+RM2+H*VM2); 
        VM1=.5*(VM1OLD+VM1+H*AM1); 
        VM2=.5*(VM2OLD+VM2+H*AM2);
        S=S+H; 
        if S>.049999 
            S=0.; 
            n=n+1; 
            ArrayT(n)=T; 
            ArrayRM1(n)=RM1; 
            ArrayRM2(n)=RM2; 
            ArrayRT1(n)=RT1; 
            ArrayRT2(n)=RT2; 
            ArrayXNCG(n)=XNC/32.2; 
        end 
    end 
    RTM
  ACC{j} = ArrayXNCG;
  TT{j} = ArrayT;
end
RTM
lw = 3;
figure(1) 
h1 = plot(ArrayRM1,ArrayRM2,ArrayRT1,ArrayRT2);
grid on
legend('Missle','Target')
xlabel('X Distance (ft)') 
ylabel('height (ft)') 
axis([0 2e4 950 1250])
set(h1,{'LineWidth'},{lw;lw})

figure(2) 
for i=1:NN
    plot(TT{i},ACC{i},linS{i},'linewidth',1); 
    hold on;
end
grid on 
xlabel('time (s)') 
ylabel('acceleration (g)') 
axis([0 5.5 -1 800])
Legend=cell(NN,1);
for iter=1:NN
   Legend{iter}=strcat('Time-to-Go = ', num2str(ttg(iter)),' (s)');
end
legend(Legend)

