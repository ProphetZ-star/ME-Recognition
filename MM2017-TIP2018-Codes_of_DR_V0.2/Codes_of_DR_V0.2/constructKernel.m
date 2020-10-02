function K = constructKernel(fea_a,fea_b,options)
% function K = constructKernel(fea_a,fea_b,options)
%	Usage:
%	K = constructKernel(fea_a,[],options)
%
%   K = constructKernel(fea_a,fea_b,options)
%
%	fea_a, fea_b  : Rows of vectors of data points. 
%
%   options       : Struct value in Matlab. The fields in options that can
%                   be set: 
%           KernelType  -  Choices are:
%               'Gaussian'      - e^{-(|x-y|^2)/2t^2}
%               'Polynomial'    - (x'*y)^d
%               'PolyPlus'      - (x'*y+1)^d
%               'Linear'        -  x'*y
%
%               t       -  parameter for Gaussian
%               d       -  parameter for Poly
%
%   version 1.0 --Sep/2006 
%
%   Written by Deng Cai (dengcai2 AT cs.uiuc.edu)
%

if (~exist('options','var'))
   options = [];
else
   if ~isstruct(options) 
       error('parameter error!');
   end
end



%=================================================
if ~isfield(options,'KernelType')
    options.KernelType = 'Gaussian';
end

switch lower(options.KernelType)
    case {lower('Gaussian')}        %  e^{-(|x-y|^2)/2t^2}
        if ~isfield(options,'t')
            options.t = 1;
        end
    case {lower('Polynomial')}      % (x'*y)^d
        if ~isfield(options,'d')
            options.d = 2;
        end
    case {lower('PolyPlus')}      % (x'*y+1)^d
        if ~isfield(options,'d')
            options.d = 2;
        end
    case {lower('Linear')}      % x'*y
    case {lower('chi2')}
    otherwise
        error('KernelType does not exist!');
end


%=================================================

switch lower(options.KernelType)
    case {lower('Gaussian')}       
        if isempty(fea_b)
            D = EuDist2(fea_a,[],0);
        else
            D = EuDist2(fea_a,fea_b,0);
        end
        K = exp(-D/(2*options.t^2));
    case {lower('Polynomial')}     
        if isempty(fea_b)
            D = full(fea_a * fea_a');
        else
            D = full(fea_a * fea_b');
        end
        K = D.^options.d;
    case {lower('PolyPlus')}     
        if isempty(fea_b)
            D = full(fea_a * fea_a');
        else
            D = full(fea_a * fea_b');
        end
        K = (D+1).^options.d;
    case {lower('Linear')}     
        if isempty(fea_b)
            K = full(fea_a * fea_a');
        else
            K = full(fea_a * fea_b');
        end
    case {lower('chi2')}
        if isempty(fea_b)
            D = zeros(size(fea_a,1),size(fea_a,1));
            for i=1:size(fea_a,1)
                d = bsxfun(@minus, fea_a, fea_a(i,:));
                s = bsxfun(@plus, fea_a, fea_a(i,:));
                D(:,i) = sum(d.^2 ./ (s/2+eps), 2);
            end       
        else
            D = zeros(size(fea_a,1),size(fea_b,1));
            for i=1:size(fea_b,1)
                d = bsxfun(@minus, fea_a, fea_b(i,:));
                s = bsxfun(@plus, fea_a, fea_b(i,:));
                D(:,i) = sum(d.^2 ./ (s/2+eps), 2);
            end
        end
        K = 1 - D;
    otherwise
        error('KernelType does not exist!');
end

if isempty(fea_b)
    K = max(K,K');
end

    
