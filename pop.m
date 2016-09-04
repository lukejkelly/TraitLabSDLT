function obj=pop(type)

%GlobalSwitches;

switch lower(type)
case 'output'
   %OUTPUT bag for samples
   obj=struct(...
      'Nsamp',{0},...
      'stats',{[]},...
      'pa',{[]},...
      'trees',{{}},...
      'cattrees',{{}},...
      'file',{''},...
      'path',{''},...
      'verbose',{[]},...
      'truefig',{101},...
      'statsfig',{102},...
      'treefig',{103},...
      'postfig',{104},...
      'histfig',{105},...
      'histfig2',{106},...
      'distdepth',{106},...
      'tmrcafig',{107},...
      'constree',{108},...
      'cladefig',{109}...
   );
case 'true'
   %DATA true
   obj=struct(...
      'wordset',{[]},...
      'state',{[]},...
      'NS',{0},...
      'mu',{0},...
      'br',{0},...
      'vocabsize',{0},...
      'beta', {0}, ... % LUKE 05/10/2013
      'lambda',{0},...
      'theta',{0},...
      'p',{1},... %DAVID 15 OCT 2003
      'rho',{0},... %RJR 28/02/07
      'kappa',{0},...
      'nu',{0},...
      'cat',[]...
      );   
case 'initial'
    global NEWTRE OFF BUILD
   %DATA initial
   obj=struct(...
      'synth',{NEWTRE},...   
      'borrow',{OFF},...
      'polymorph',{OFF},...
      'nmeaningclass',{1},...
      'source',{BUILD},...
      'file',{''},...
      'treefile',{''},...
      'tree',{[]},...  % DAVID 21 OCT 2002
      'lost',{0},...
      'mask',{[]}...
      );
case 'content'
   %DATA content
   obj=struct(...
      'array',{[]},...
      'NS',{0},...
      'L',{0},...
      'language',{[]},...
      'cognate',{[]}...
      );
case 'model'
   %MODELS
   obj.prior=struct(...
      'type',{0},...
      'FlatMax',{0},...
      'isclade',{0},...
      'clade',{0},...
      'strongclades',{0},...
      'upboundclade',{0},...
      'isupboundadamclade',{0},...
      'topologyprior',{0}...
      );
   obj.observe=struct(...
      'LostOnes',{0},...
      'lossrate',{0.18}...
      );   
case 'state'
   obj=struct(...
      'NS',{0},...
      'L',{0},...
      'mu',{0},...
      'lambda',{0},...
      'p',{0},...
      'tree',{[]},...
      'root',{[]},...
      'leaves',{[]},...
      'nodes',{[]},...
      'claderoot',{[]},...
      'loglkd',{[]},...
      'logprior',{[]},...
      'fullloglkd',{0},...
      'cat',{[]},...
      'ncat',{0}, ...
      'beta', {0} ...
      );
case 'node'
   obj=struct(...
      ... %topology
      'parent',{[]},...
      'sibling',{[]},...
      'child',{[]},...
      ... %state variables
      'time',{[]},...
      ... %properties
      'Name',{[]},...
      'type',{[]},...
      'clade',{[]},...
      'unclade',{[]},...
      'timedata',{{[],[]}},...
      'dat',{[]},...
      ... %likelihood: store part results
      'u',{[]},...
      'v',{[]},...
      'LamInt',{[]},...
      'w',{[]},...
      'PD',{[]},...
      'ActI',{{[],[],[]}},...
      'CovI',{[]},...
      'difCovI',{[]},...
      'Tu',{[]},...
      'TActI',{{[],[],[]}},...
      'TCovI',{[]},...
      'TdifCovI',{[]},...
      ... %likelihood: update at change
      'mark',{0},...
      ... %prior leaf time constraint
      'leaf_has_timerange',{0},...
      'timerange',{[]},...
      'PDcat',{0},...
      'CatLamInt',{0},...
      'n',[],...
      'd',[],...
      'cat',{0},...
      'xi',1-rand^3, ...
      ... % Luke's catastrophe stuff 07/02/2014
      'catloc', {[]}, ...
      ... % Luke's branch indexing stuff 28/03/2014
      'order', {[]} ...
      );
case 'clade'
   obj=struct(...
      'language',{{}},...
      'name',{''},...
      'rootrange',{[]},...
      'adamrange',{[]},...
      'lowlim',{[]}...
      );
case 'fsu'
   obj=struct(...
      'RUNLENGTH',{[]},...
      'SUBSAMPLE',{[]},...
      'SEEDRAND',{[]},...
      'SEED',{[]},...
      'MCMCINITBETA', 0.005, ... % LUKE 05/10/2013
      'MCMCINITTREESTYLE',{[]},...
      'MCMCINITTREEFILE',{''},...
      'MCMCINITTREE',{[]},...
      'MCMCINITTREENUM',{[]},...
      'MCMCINITMU',{[]},...
      'MCMCINITP',{[]},...
      'MCMCINITTHETA',{[]},...
      'MCMCVARYTOP',{1},...
      'VERBOSE',{[]},...
      'OUTFILE',{''},...
      'OUTPATH',{''},...
      'DATASOURCE',{[]},...
      'DATAFILE',{''},...
      'DATASYN',{[]},...
      'TREEPRIOR',{[]},...
      'ROOTMAX',{[]},...
      'MASKING',{[]},...
      'DATAMASK',{[]},...
      'ISCOLMASK',{[]},...
      'COLUMNMASK',{[]},...
      'LOSTONES',{[]},...
      'LOST',{[]},...
      'LOSSRATE',{[]},...
      'ISLRRANDOM',{[]},... %'LOSSRATESHAPE',{[]},... unused RJR 17 Mar 2011
      'LOSSRATEBRANCHVAR',{0},...
      'LOSSRATECLASSVAR',{0},...
      'PSURVIVE',{[]},...
      'ISCLADE',{[]},...
      'CLADEMASK',{[]},...
      'CLADEAGESMASK',{[]},...
      'CLADE',{{}},...
      'SYNTHSTYLE',{[]},...
      'SYNTHTREFILE',{''},...
      'SYNTHTRE',{[]},...
      'KNOWCATS',{0},...
      'BORROW',{[]},...
      'BORROWFRAC',{[]},...
      'BORROWING', {0}, ... % LUKE 05/10/2013
      'LOCALBORROW',{[]},...   
      'MAXDIST',{[]},...
      'POLYMORPH',{[]},...
      'NMEANINGCLASS',{[]},...
      'NUMSEQ',{[]},...
      'VOCABSIZE',{[]},...
      'THETA',{[]},...
      'GUITRUE',{[]},...
      'GUICONTENT',{[]},...
      'SYNTHCLADES',{0},...
      'MCMCMISS',{0},...
      'VARYRHO',{0},...
      'VARYKAPPA',{0},...
      'VARYMU',{[]},...
      'VARYBETA', {0}, ... LUKE 05/10/2013
      'MCMCINITKAPPA',{rand},...
      'MCMCINITLAMBDA',{[]},...
      'MCMCINITRHO',{[]},...
      'MCMCCAT',{0},...
      'TOPOLOGYPRIOR',{0},...
      'SYNTHMISS',{[]},...
      'NUMSYNTHCLADES',{[]},...
      'SYNTHCLADESACCURACY',{[]},...
      'SYNTHCLADESTIMES',{[]},...
      'LAMBDA',{[]},...
      'RHO',{[]},...
      'KAPPA',{rand},...
      'DEPNU',{1},...
      'DONTMOVECATS',{0},...
      'GF_START', {0}, ... % LUKE 12/11/2014
      'GF_APPROX', {1} ... % LUKE 12/11/2014
  );
end


