function [hNew,hGen]=testErgodicHMM%test of HMM design%Arne Leijon 2006-05-12 testedc='rbgk';%state color coding, max 4 states%ergodic generator HMM:% nStates=2;% A=[.95 .05; .05 .95];% p0=[0.5;0.5];nStates=3;A=[.95 .03 .02; .03 .95 .02;.03 0.02 0.95];p0=[1;1;1];mc=MarkovChain(p0,A);%fairly difficult for ergodic HMM, because GaussD are highly overlappingpDgen(1)=GaussD('Mean',[0 0],'StDev',[3 1]);pDgen(2)=GaussD('Mean',[+1 0],'StDev',[1 3]);pDgen(3)=GaussD('Mean',[-1 0],'StDev',[1 3]);%hGen=HMM('MarkovChain',mc,'OutputDistr',pDgen);hGen=HMM(mc,pDgen);%Make many training data sequences:xTraining=zeros(2,0);%training datalxT=[];%lengths of sub-sequencessT=[];%generator statesfor i=1:3    [x,s]=rand(hGen,2000);    xTraining=[xTraining,x];    sT=[sT,s];    lxT=[lxT,size(x,2)];end;hNew=InitErgodicHMM(nStates,[],GaussD,xTraining,lxT);for nTraining=1:10    figure;    plotTraining(xTraining,sT,c);    %also plot error points, as classified by viterbi...    plotCross(hNew.OutputDistr,[1 2],c); 	axis([-10 10 -10 10]);	hold off;%	pause;    %one training step:    ixT=cumsum([1,lxT]);%start index for each sub-sequence    aS=adaptStart(hNew);    for r=1:length(lxT)        aS=adaptAccum(hNew,aS,xTraining(:,ixT(r):(ixT(r+1)-1)));    end;    hNew=adaptSet(hNew,aS);end;hNew=setStationary(hNew);function plotTraining(xT,sT,c);nStates=max(sT);for s=1:nStates    plot(xT(1,sT==s),xT(2,sT==s),['o',c(s)],'MarkerSize',1.5);    hold on;end;