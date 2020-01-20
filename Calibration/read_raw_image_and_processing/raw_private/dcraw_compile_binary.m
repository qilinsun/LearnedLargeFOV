function compiled = dcraw_compile_binary(compile)
  % compile dcraw as binary when does not exist yet
  
  compiled = ''; 
  if nargin == 0, compile = ''; end
  if ismac,      precmd = 'DYLD_LIBRARY_PATH= ;';
  elseif isunix, precmd = 'LD_LIBRARY_PATH= ; '; 
  else           precmd=''; end
  
  if ispc, ext='.exe'; else ext=''; end
  this_path = fullfile(fileparts(which(mfilename)));
  
  % try in order: global(system), local, local_arch
  for try_target={ ...
          [ 'dcraw' ext ], 'dcraw', ...
          fullfile(this_path, [ 'dcraw_' computer('arch') ext ]), ...
          fullfile(this_path, [ 'dcraw' ext ]) }
      
    [status, result] = system([ precmd try_target{1} ]); % run from Matlab

    if status == 1 && nargin == 0 && ~isempty(strfind(result, 'Coffin'))
        % the executable is already there. No need to make it.
        compiled = try_target{1};
        return
    end
  end
  
  % when we get there, compile dcraw_arch, not existing yet
  target = fullfile(this_path, [ 'dcraw_' computer('arch') ext ]);

  % search for a C compiler
  cc = '';
  for try_cc={getenv('CC'),'cc','gcc','ifc','pgcc','clang','tcc'}
    if ~isempty(try_cc{1})
      [status, result] = system([ precmd try_cc{1} ]);
      if status == 4 || ~isempty(strfind(result,'no input file'))
        cc = try_cc{1};
        break;
      end
    end
  end
  if isempty(cc)
    if ~ispc
      disp([ mfilename ': ERROR: C compiler is not available from PATH:' ])
      disp(getenv('PATH'))
      disp([ mfilename ': You may have to extend the PATH with e.g.' ])
      disp('setenv(''PATH'', [getenv(''PATH'') '':/usr/local/bin'' '':/usr/bin'' '':/usr/share/bin'' ]);');
    end
    error('%s: Can''t find a valid C compiler. Install any of: gcc, ifc, pgcc, clang, tcc\n', ...
    mfilename);
  else
    try
      fprintf(1, '%s: compiling dcraw binary (using %s)...\n', mfilename, cc);
      cmd={cc, '-O2','-o',target, ...
        fullfile(this_path,'dcraw.c'),'-lm','-DNODEPS'};
      cmd = sprintf('%s ',cmd{:});
      disp(cmd)
      [status, result] = system([ precmd cmd ]);
      if status == 0
        compiled = target;
      end
    end
  end

  if isempty(compiled) && ~isempty(compile)
    error('%s: Can''t compile dcraw.c binary\n       in %s\n', ...
        mfilename, fullfile(this_path));
  end
  

