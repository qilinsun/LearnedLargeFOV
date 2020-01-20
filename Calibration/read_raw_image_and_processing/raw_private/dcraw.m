function [im, info, output] = dcraw(exe, files, options)

  % useful DCRAW options
  % -T              write a TIFF file, and copy metadata in
  % -H 2
  % -w -T -6 -q 3   use camera white balance, and best interpolation
  % -a -T -6        use auto white balance
  % -i -v           print metadata
  % -z              set the generated image date to that of the camera
  % -n 100          remove noise using wavelets
  % -w              use white balance from camera or auto
  
  if ismac,      precmd = 'DYLD_LIBRARY_PATH= ; ';
  elseif isunix, precmd = 'LD_LIBRARY_PATH= ; '; 
  else           precmd=''; end
  
  if nargin < 3, options='-T -w -6 -v'; end
  
  if ischar(options), options= cellstr(options); end
  
  if ischar(files), files=cellstr(files); end
  im = {}; info = {}; output = {};
  
  for index=1:numel(files)
    file = files{index};
    [p,f]= fileparts(file);
    
    % we first check if the output file already exists. If so we just read it.
    flag_output = '';
    for ext={'.tiff', '.pnm','.ppm','.pgm'}
      out = fullfile(p, [f ext{1} ]);
      if exist(out, 'file')
        flag_output = out;
        break
      end
    end
    if ~isempty(flag_output) && isempty(strfind(char(options), '-i'))
      im{end+1}   = imread(flag_output);
      info{end+1} = imfinfo(flag_output);
      output{end+1} = flag_output;
      break
    end
  
    cmd       = [ precmd exe ' ' sprintf('%s ', options{:}) file ];
    disp(cmd)

    % launch the command
    [status, result] = system([ cmd ]);
    if status, continue; end
    
    % interpret the result: image or information
    tokens = { 'Scaling with darkness', 'Scaling_Darkness:';
               ', saturation',          '; Scaling_Saturation:';
               'multipliers',           'Multipliers:';
               'Writing data to',       'Filename:';
               ', and',                 ''};
    for tokid = 1:size(tokens,1)
      result = strrep(result, tokens{tokid,1}, tokens{tokid,2});
    end
    info{end+1} = str2struct(result);
    flag_output = '';
    for ext={'.tiff', '.pnm','.ppm','.pgm'}
      out = fullfile(p, [f ext{1} ]);
      if exist(out, 'file')
        if  isempty(strfind(char(options), '-i'))
          im{end+1}   = imread(out);
        else
          im{end+1} = [];
        end
        flag_output = out;
        output{end+1} = out;
        break
      end
    end
    if isempty(flag_output), im{end+1} = []; output{end+1} = ''; end
  end
  
  % single output ?
  if numel(im) == 1
    im     = im{1};
    info   = info{1};
    output = output{1};
  end
  

end % dcraw
