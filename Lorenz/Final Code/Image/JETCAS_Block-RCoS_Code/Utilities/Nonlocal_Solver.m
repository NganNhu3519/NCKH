function [ImgRec] = Nonlocal_Solver(ImgInput, v, Opts)

if ~isfield(Opts,'PatchSize')
    Opts.PatchSize = 8;
end

if ~isfield(Opts,'Profile')
    Opts.Profile = 'normal';
end

if strcmp(Opts.Profile, 'normal')
    SlidingDis   =  2;
elseif strcmp(Opts.Profile, 'fast')
    SlidingDis   =  4;
end

if ~isfield(Opts,'Factor')
    Opts.Factor = 2.8;
end

if ~isfield(Opts,'ArrayNo')
    Opts.ArrayNo = 10;
end

if ~isfield(Opts,'SearchWin')
    Opts.SearchWin = 20;
end


[Hight Width]   =   size(ImgInput);
SearchWin = Opts.SearchWin;
PatchSize    =    Opts.PatchSize;
PatchSize2    =   PatchSize*PatchSize;
ArrayNo   =   Opts.ArrayNo;
Threshold = Opts.Factor*v;

N     =  Hight-PatchSize+1;
M     =  Width-PatchSize+1;
L     =  N*M;

Row     =  [1:SlidingDis:N];
Row     =  [Row Row(end)+1:N];
Col     =  [1:SlidingDis:M];
Col    =  [Col Col(end)+1:M];

PatchSet     =  zeros(PatchSize2, L, 'single');

DctMatrix = dct(eye(ArrayNo));
IWaveletMatrix = [0.3536    0.3739    0.5146   -0.0000    0.7071   -0.1215    0.0000    0.1215;
    0.3536    0.3739    0.5146   -0.0000   -0.7071   -0.1215    0.0000    0.1215;
    0.3536    0.3739   -0.5146   -0.0000    0.1215    0.7071   -0.1215   -0.0000;
    0.3536    0.3739   -0.5146    0.0000    0.1215   -0.7071   -0.1215    0.0000;
    0.3536   -0.3739         0    0.5146         0    0.1215    0.7071   -0.1215;
    0.3536   -0.3739         0    0.5146         0    0.1215   -0.7071   -0.1215;
    0.3536   -0.3739         0   -0.5146   -0.1215   -0.0000    0.1215    0.7071;
    0.3536   -0.3739         0   -0.5146   -0.1215   -0.0000    0.1215   -0.7071];
WaveletMatrix = inv(IWaveletMatrix);

Count     =  0;
for i  = 1:PatchSize
    for j  = 1:PatchSize
        Count    =  Count+1;
        Patch  =  ImgInput(i:Hight-PatchSize+i,j:Width-PatchSize+j);
        Patch  =  Patch(:);
        PatchSet(Count,:) =  Patch';
    end
end

PatchSetT  =   PatchSet';

I        =   (1:L);
I        =   reshape(I, N, M);
NN       =   length(Row);
MM       =   length(Col);

ImgTemp     =  zeros(Hight, Width);
ImgWeight   =  zeros(Hight, Width);
IndcMatrix  =  zeros(NN, MM, ArrayNo);
PatchArray  =  zeros(PatchSize, PatchSize, ArrayNo);

%tic;

for  i  =  1 : NN
    for  j  =  1 : MM
        
        CurRow      =   Row(i);
        CurCol      =   Col(j);
        Off      =   (CurCol-1)*N + CurRow;
        
        CurPatchIndx  =  PatchSearch(PatchSetT, CurRow, CurCol, Off, ArrayNo, SearchWin, I);
        %IndcMatrix(i,j,:) = CurPatchIndx;
        
        CurArray = PatchSet(:, CurPatchIndx);
        
        for k = 1:ArrayNo
            PatchArray(:,:,k) = reshape(CurArray(:,k),PatchSize,PatchSize);
        end
        
        TranArray = DWT2DCT(PatchArray,DctMatrix,WaveletMatrix);
        Z = TranArray.*(abs(TranArray)>Threshold);
        NonZero = length(find(Z>0));
        PatchArray = real(IDWT2DCT(Z,DctMatrix,IWaveletMatrix));
        
        for k = 1:length(CurPatchIndx)
            RowIndx  =  ComputeRowNo((CurPatchIndx(k)), N);
            ColIndx  =  ComputeColNo((CurPatchIndx(k)), N);
            ImgTemp(RowIndx:RowIndx+7, ColIndx:ColIndx+7)    =   ImgTemp(RowIndx:RowIndx+7, ColIndx:ColIndx+7) + PatchArray(:,:,k)';
            ImgWeight(RowIndx:RowIndx+7, ColIndx:ColIndx+7)  =   ImgWeight(RowIndx:RowIndx+7, ColIndx:ColIndx+7) + 1;
        end
        
    end
end

%save ('IndcMatrix.mat', 'IndcMatrix');
ImgRec = ImgTemp./(ImgWeight+eps);

%toc;

return;



