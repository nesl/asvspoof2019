classdef Results
% A class that produces various measures describing system accuracy.

properties (SetAccess = private)
  tar
  non
  numtar
  numnon
  Pmiss
  Pfa
  eer
  pb
end

methods
  % res = Results(scr,key);
  % res = Results(tar,non);
  function res = Results(param1,param2)
    if isnumeric(param1)
        assert(isnumeric(param2))
        res.tar = param1;
        res.non = param2;
    else
        scr = param1;
        key = param2;
        assert(isa(scr,'Scores'))
        assert(isa(key,'Key'))
        [res.tar, res.non] = scr.get_tar_non(key);
    end
    [res.Pmiss,res.Pfa] = rocch(res.tar,res.non);
    res.eer = rocch2eer(res.Pmiss,res.Pfa);
    res.numtar = length(res.tar);
    res.numnon = length(res.non);
    Nmiss = res.Pmiss * res.numtar;
    Nfa = res.Pfa * res.numnon;
    res.pb = rocch2eer(Nmiss,Nfa);
  end
  function actdcf = get_act_dcf(res,prior)
    actdcf = fast_actDCF(res.tar,res.non,logit(prior),false);    
  end
  function mindcf = get_min_dcf(res,prior)
    Ptar = prior;
    Pnon = 1-prior;
    cdet = [Ptar,Pnon]*[res.Pmiss(:)';res.Pfa(:)'];
    mindcf = min(cdet,[],2);
  end
  function actdcf = get_norm_act_dcf(res,prior)
    actdcf = fast_actDCF(res.tar,res.non,logit(prior),true);
  end
  function mindcf = get_norm_min_dcf(res,prior)
    Ptar = prior;
    Pnon = 1-prior;
    cdet = [Ptar,Pnon]*[res.Pmiss(:)';res.Pfa(:)'];
    mindcf = min(cdet,[],2) ./ min(Ptar,Pnon);        
  end
  function pb = get_prbep(res)
    pb = res.pb;
  end
  function eer_val = get_eer(res)
    eer_val = res.eer;
  end
  function ntar = num_tar(res)
    ntar = res.numtar;
  end
  function nnon = num_non(res)
    nnon = res.numnon;
  end
end

end

