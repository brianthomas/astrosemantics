#!/usr/bin/perl -w
 
package AstroSemantics::TextProcessing;

#use List::MoreUtils qw/uniq/;

# these various items end in an 's' but because they are special 'jargon'
# don't follow the usual rules for making them singular
my @NONPLURAL_S_TERMS = qw/axis axes ephemerides acrs ascagis ascagps ascalss ascasis batsetrigs baxgalclus
bootes cfa2s eingalclus exms exogps exohgls exss fpcsfits gravitational_lens gcvsegvars gcvsnsvars hipparcos
interstellar_gas iras ipcostars lens macs mars magpis magnetohydrodynamics noras nucleus obs rasscals rassebcs rassimages rassvars revisedlhs rixos ros400gcls rosgalclus
sumss swifttdrss vlacosmos voparis wenss xteobs zeus astrophysics cosmos debris gas heliophysics physics texas/;

my $DEBUG = 0;
my $CHATTY = 0;

sub setChatty ($) { $CHATTY = shift; }
sub setDebug ($) { $DEBUG = shift; }

sub make_singular($) 
{
  my ($word) = @_;

  # deal with special formatting first, split up colon-separated words
#  if($word =~ m/^([\W|\w]+)\:+([\W|\w]+)$/i)
#  {
#        my $first = &make_singular($1);
#        my $second = &make_singular($2);
#        return $first . ":". $second;
#  }

  if ($word =~ m/s$/ or $word =~ m/ei$/ or $word =~ m/ae$/) {

    # items which lack vowels or any lowercase letters are probably acronyms
    # and we can skip them
    if ($word =~ m/(a|e|i|o|u|y)/i 
          and 
        $word !~ m/\w+rus$/i
          and
        $word !~ m/\w+ous$/i
          and
        $word !~ m/\w+ysis$/i
          and
        $word !~ m/\w+gas$/i
          and
        $word !~ m/\w+ss$/i
       ) 
    {

      return $word if (_is_a_tech_term($word));

      print STDERR "GOT possible PLURAL word:[$word] " if $DEBUG;
      my $start_word = $word;
      if ($word =~ m/^([\w|\s|\-|\_]+)(ies)$/i) 
      {
        $word = $1 . "y" unless ($word =~ m/^\w*series$/i);
      }
      elsif ($word =~ m/^([\w|\s|\-|\_]+)(bases)$/i) 
      {
        $word = $1 . "base";
      }
      elsif ($word =~ m/^([\w|\s|\-|\_]+)(clei)$/i) 
      {
        $word = $1 . "cleus";
      }
      elsif ($word =~ m/^([\w|\s|\-|\_]+)(ulae)$/i) 
      {
        $word = $1 . "ula";
      }
      elsif ($word =~ m/^([\w|\s|\-|\_]+)(vae)$/i) 
      {
        $word = $1 . "va";
      }
      elsif ($word =~ m/^([\w|\s|\-|\_]+)(ses)$/i) 
      {
        $word = $1 . "s";
      }
      elsif ($word =~ m/^([\w|\s|\-|\_]+)(xes)$/i) 
      {
        $word = $1 . "x";
      }
      elsif ($word =~ m/^([\w|\s|\-|\_]+)(xus)$/i) 
      {
        $word = $1 . "x";
      }
      elsif ($word =~ m/^([\w|\s|\-|\_]+)(s)$/i) 
      {
        $word = $1;
      } 
      $PLURAL{$word} = 1 if ($start_word ne $word);

      print STDERR "returning word:[$word]\n" if $DEBUG;
    }

  } 
  return $word;
}

# get an id suitable for a class in an ontology 
#
sub getClassId ($) {
  my ($id) = @_;

  return $id unless defined $id;
 
  $id =~ s/\s//g; # remove all whitespace 

  while ($id && $id =~ m/^[#|\-]/) { 
    $id =~ s/^#//g; # remove all leading hash 
    $id =~ s/^(\-*)//g; # remove all leading dashes
  }
#  $id =~ s/_//g;
  $id =~ s/\-//g unless ($id =~ m/\-\-/); # "--" is significant, but "-" is not 

  # leading numbers are illegal in ontologies, convert to string
  # representation 
  if ($id =~ m/^(\d+)(.*)$/) { 
    my $num = $1; my $tail = $2; 
    $num =~ s/1/one/g;
    $num =~ s/2/two/g;
    $num =~ s/3/three/g;
    $num =~ s/4/four/g;
    $num =~ s/5/five/g;
    $num =~ s/6/six/g;
    $num =~ s/7/seven/g;
    $num =~ s/8/eight/g;
    $num =~ s/9/nine/g;
    $num =~ s/0/zero/g;
    $id = $num . $tail;
  }

  return &make_singular(lc $id);
}

sub _is_a_tech_term($) {
  my ($str) = @_;

  my $t = lc $str;

  # astroterm
#  if ($t eq "near ir") { return 1; } 
#  if ($t =~ m/white dwarf/) { return 1; } 
  if ($t =~ m/nucleus$/) { return 1; } 
  if ($t =~ m/physics$/) { return 1; } 
  if ($t =~ m/bootes$/) { return 1; } 
  foreach my $term (@NONPLURAL_S_TERMS) { if ($t eq $term) { return 1; } }

  return 0;
}

1;
