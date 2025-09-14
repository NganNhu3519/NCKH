%
% test Maximum Likelihood
%
clear
n= 5;
z= (-10:.01:10)';
X = .1*randn(n,1)+1;


mus = -9:.1:9;
lik=zeros(length(mus),1);
for i=1:length(mus),
    % normal
    %f = exp(-(z-mus(i)).^2)/sqrt(2*pi*1);
    %lik(i) = exp(-sum( (X-mus(i)).^2))/sqrt(2*pi*1);
    
    % uniform
    f = .5*( abs(z-mus(i))<1);
    lik(i) = prod( .5*real(abs(X-mus(i))<1) );
    
    
    figure(1)
    subplot(1,2,1);
    h=plot(X,.1*ones(n,1),'o',z,f,'k-');
    set(h,'LineWidth',3)
    axis([-10 10 -.2 1.2])
    xlabel('x')
    ylabel('p_\mu(x)')
    title(['\mu = ' num2str(mus(i))])
    grid;
    
    subplot(1,2,2);
    h=plot(mus(1:i),lik(1:i),'k-');
    set(h,'LineWidth',3)
    axis([-10 10 -eps 1.2*max(lik)])
    xlabel('mu')
    ylabel('L(mu; X)')
    title('total likelihood of p_\mu')
    grid;
    drawnow;
    pause(.1)
    
    
end