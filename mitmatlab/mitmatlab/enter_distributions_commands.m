function enter_distributions_commands(command, param)

%This functions handles callbacks from the enter_distributions GUI

switch command
case 'change_parameter'
   %When there are changes to one of the parameters of a Gaussian, save it to file.
   %Used by the manual entry screen.
   
   load synthetic
   
   tag			= get(param, 'Tag');
   val 			= get(findobj('Tag', 'popNumber'), 'Value');
   zero_or_one = ~get(findobj('Tag', 'rbtClass0'), 'Value');
   num			= str2num(get(param, 'String'));
   
   switch tag
   case 'txtMeanX'
      if zero_or_one,
         distribution_parameters.m1(val,1) = num;
      else
         distribution_parameters.m0(val,1) = num;
      end
   case 'txtMeanY'
      if zero_or_one,
         distribution_parameters.m1(val,2) = num;
      else
         distribution_parameters.m0(val,2) = num;
      end
   case 'txtWeight'
      if zero_or_one,
         distribution_parameters.w1(val) = num;
      else
         distribution_parameters.w0(val) = num;
      end
   case 'txtCov11'
      if zero_or_one,
         distribution_parameters.s1(val,1,1) = num;
      else
         distribution_parameters.s0(val,1,1) = num;
      end
   case 'txtCov12'
      if zero_or_one,
         distribution_parameters.s1(val,1,2) = num;
      else
         distribution_parameters.s0(val,1,2) = num;
      end
   case 'txtCov21'
      if zero_or_one,
         distribution_parameters.s1(val,2,1) = num;
      else
         distribution_parameters.s0(val,2,1) = num;
      end
   case 'txtCov22'
      if zero_or_one,
         distribution_parameters.s1(val,2,2) = num;
      else
         distribution_parameters.s0(val,2,2) = num;
      end
   end
   
   save synthetic distribution_parameters
   
case 'change_class'
   %Change the display of a class, when one of the radio buttons is pressed.
   %Used by the manual entry screen.
   
   load synthetic
   
   h0 = findobj('Tag', 'rbtClass0');       
   h1 = findobj('Tag', 'rbtClass1');       
   h  = findobj('Tag', 'txtCount');
   hp = findobj('Tag', 'popNumber');                                                                     
   n0 = size(distribution_parameters.s0,1);
   n1 = size(distribution_parameters.s1,1);
   
   if param,
      set(h0, 'Value', not(get(h1, 'Value')));
   else
      set(h1, 'Value', not(get(h0, 'Value')));
   end
   
   
   %Set the number of Gaussians (if they exist)
   if (get(h0, 'Value'))
      if (n0>0),
         set(h, 'String', ['There are ' num2str(n0) ' Gaussians in this class'])
         s = cell(n0, 1);                                                                                    
         for i=1:n0,                                                                                         
            s(i) =  cellstr(num2str(i));                                                                      
         end                                                                                                  
         set(hp, 'String', s')                                                                                 
         set(hp, 'Value', 1)                                                                                 
         set(hp, 'Max', n0);                                                                                  
      end
   else
      if (n1>0),
         set(h, 'String', ['There are ' num2str(n1) ' Gaussians in this class'])
         s = cell(n1, 1);                                                                                    
         for i=1:n1,                                                                                         
            s(i) =  cellstr(num2str(i));                                                                      
         end                                                                                                  
         set(hp, 'String', s')                                                                                 
         set(hp, 'Value', 1)                                                                                 
         set(hp, 'Max', n1);                                                                                     
      end
   end
   
   enter_distributions_commands('change_gaussian')
   
case 'change_gaussian'
   %When the user selects a different Gaussian, change the display to show that Gaussian.
   %Used by the manual entry screen.
   
   load synthetic
   
   h 		= findobj('Tag', 'popNumber');
   hm1 	= findobj('Tag', 'txtMeanX');
   hm2 	= findobj('Tag', 'txtMeanY');
   hw 	= findobj('Tag', 'txtWeight');
   hs11  = findobj('Tag', 'txtCov11');
   hs12  = findobj('Tag', 'txtCov12');
   hs21  = findobj('Tag', 'txtCov21');
   hs22  = findobj('Tag', 'txtCov22');
   
   val = get(h, 'Value');
   
   if get(findobj('Tag', 'rbtClass0'), 'Value')
      %Class 0 selected
      set(hm1,  'String', distribution_parameters.m0(val,1))
      set(hm2,  'String', distribution_parameters.m0(val,2))
      set(hs11, 'String', distribution_parameters.s0(val,1,1))
      set(hs12, 'String', distribution_parameters.s0(val,1,2))
      set(hs21, 'String', distribution_parameters.s0(val,2,1))
      set(hs22, 'String', distribution_parameters.s0(val,2,2))
      set(hw, 'String', distribution_parameters.w0(val))
   else
      %Class 1 selected
      set(hm1,  'String', distribution_parameters.m1(val,1))
      set(hm2,  'String', distribution_parameters.m1(val,2))
      set(hs11, 'String', distribution_parameters.s1(val,1,1))
      set(hs12, 'String', distribution_parameters.s1(val,1,2))
      set(hs21, 'String', distribution_parameters.s1(val,2,1))
      set(hs22, 'String', distribution_parameters.s1(val,2,2))
      set(hw,   'String', distribution_parameters.w1(val))
   end   
otherwise
   error('Unknown command')
end
