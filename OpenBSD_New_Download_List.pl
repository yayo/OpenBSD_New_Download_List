# perl OpenBSD_New_Download_List.pl OpenBSD_Old_Download_List.txt index.txt  | cut -d' ' -f5- | sed -e 's/ /\n/g' | sort | uniq

if(2!=scalar(@ARGV))
 {warn("Usage:");
 }
else
 {if(!open(FILE,'<'.$ARGV[1]))
   {warn("Cannot open new filename index: ".$ARGV[1]);
   }
  else
   {my %new;
    while(<FILE>)
     {my @line=split(/\s+/,$_);
      if(10!=scalar(@line))
       {warn($_);
        exit(-1);
       }
      $_=$line[9];
      $_ =~ s/^\s+//;
      $_ =~ s/\s+$//;
      my $k=$_;
      for(my $i=0;0<length($_);$i++)
       {if(!exists($new{$_}))
         {$new{$_}=[$i,0!=$i?substr($k,-$i):''];
         }
        else
         {if($i<${$new{$_}}[0])
           {$new{$_}=[$i,0!=$i?substr($k,-$i):''];
           }
          elsif($i==${$new{$_}}[0])
           {push(@{$new{$_}},0!=$i?substr($k,-$i):'');
           }
         }
        $_=substr($_,0,length($_)-1);
       }
     }
    close(FILE);
    if(!open(FILE,'<'.$ARGV[0]))
     {warn("Cannot open old filename list: ".$ARGV[0]);
     }
    else
     {while(<FILE>)
       {$_ =~ s/^\s+//;
        $_ =~ s/\s+$//;
        my $k=$_;
        my $i=0;
        for(;0<length($k) && !exists($new{$k});$i++)
         {$k=substr($k,0,length($k)-1);
         }
        if(0>=length($k))
         {warn($_);
          exit;
         }
        else
         {print($_.' '.$i.' '.$k.' '.${$new{$k}}[0].' '.join(' ', map({$k.$_} @{$new{$k}}[1..scalar(@{$new{$k}})-1]))."\n");
         }
       }
      close(FILE);
     }
   } 
 }
