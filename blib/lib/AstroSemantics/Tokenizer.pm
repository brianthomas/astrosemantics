#!/usr/bin/perl -w
 
package AstroSemantics::Tokenizer;

use AstroSemantics::TextProcessing;
use List::MoreUtils qw/uniq/;


my %AMERICAN_ENGLISH;
$AMERICAN_ENGLISH{'astronimical'} = 'astronomical';
$AMERICAN_ENGLISH{'catalogue'} = 'catalog';
$AMERICAN_ENGLISH{'organisation'} = 'organization';
$AMERICAN_ENGLISH{'validator'} = 'validater';

# Various compound words which might be hyphened or have
# a space separating 2 words which should be kept together
# rather than made into separate tokens 
my %COMPOUND_WORD;
$COMPOUND_WORD{'absolute\s*magnitude'} = "absolute_magnitude"; 
$COMPOUND_WORD{'absolute\s*proper_motion'} = "absolute_proper_motion"; 
$COMPOUND_WORD{'apparent\s*magnitude'} = "apparent_magnitude"; 
$COMPOUND_WORD{'active\s*galactic[\s|\-]+nuclei'} = "active_galactic_nucleus"; 
$COMPOUND_WORD{'atmospheric\s*effect'} = "atmospheric_effect"; 
$COMPOUND_WORD{'be\s*star'} = "be_star"; 
$COMPOUND_WORD{'binary\s*star'} = "binary_star"; 
$COMPOUND_WORD{'bl\s*lac'} = "bl_lac_object"; 
$COMPOUND_WORD{'bl\s*lac\s*object'} = "bl_lac_object";
$COMPOUND_WORD{'bright\s*star'} = "bright_star"; 
$COMPOUND_WORD{'brown\s*dwarf'} = "brown_dwarf"; 
$COMPOUND_WORD{'cataclysmic\s*binary'} = "cataclysmic_binary"; 
$COMPOUND_WORD{'cataclysmic\s*variable'} = "cataclysmic_variable"; 
$COMPOUND_WORD{'cet\s*type'} = "cet_type"; 
$COMPOUND_WORD{'collapsed\s*star'} = "collapsed_star"; 
$COMPOUND_WORD{'cool\s*star'} = "cool_star"; 
$COMPOUND_WORD{'computer\s*simulation'} = "computer_simulation"; 
$COMPOUND_WORD{'cosmic\s*microwave\s*background'} = "cosmic_microwave_background"; 
$COMPOUND_WORD{'dark\s*energy'} = "dark_energy"; 
$COMPOUND_WORD{'dark\s*matter'} = "dark_matter"; 
$COMPOUND_WORD{'data\s+base'} = "database"; 
$COMPOUND_WORD{'data[\s|\-]*repository'} = "data_repository"; 
$COMPOUND_WORD{'data\s+store'} = "datastore"; 
#$COMPOUND_WORD{'digital[\s|\-]+library'} = "digital_library";
$COMPOUND_WORD{'distance\s*redshift'} = "redshift_distance";
$COMPOUND_WORD{'double\s+star'} = "double_star"; 
$COMPOUND_WORD{'early\s*type\s*star'} = "earlytype_star"; 
$COMPOUND_WORD{'early\s*type\s*gal'} = "earlytype_gal"; 
$COMPOUND_WORD{'echelle\s*spectra'} = "echelle_spectra"; 
$COMPOUND_WORD{'eclipsing\s*binary'} = "eclipsing_binary"; 
$COMPOUND_WORD{'emission\s*st'} = "emission_st"; 
$COMPOUND_WORD{'energy\s*spectra'} = "energy_spectra"; 
$COMPOUND_WORD{'extreme\s*ultraviolet'} = "extreme_ultraviolet"; 
$COMPOUND_WORD{'extreme\s*uv'} = "extreme_uv"; 
$COMPOUND_WORD{'extra\s*solar\s*planet'} = "extra_solar_planet";
$COMPOUND_WORD{'fultraviolet'} = "farultraviolet";
$COMPOUND_WORD{'finding\s*chart'} = "finding_chart";
$COMPOUND_WORD{'flare\s*star'} = "flare_star";
$COMPOUND_WORD{'fundamental\s*star'} = "fundamental_star";
$COMPOUND_WORD{'gamma\s*ray'} = "gamma_ray";
$COMPOUND_WORD{'galaxy\s*cluster'} = "galaxy_cluster";
$COMPOUND_WORD{'galaxy\s*group'} = "galaxy_group";
$COMPOUND_WORD{'gas\s*exchange'} = "gas_exchange";
$COMPOUND_WORD{'gravitational[\s]*lens'} = "gravitational_lens";
$COMPOUND_WORD{'green\s*bank'} = "observatory--green_bank";
$COMPOUND_WORD{'ground\s*based\s*astronomy'} = "ground_based_astronomy"; 
#$COMPOUND_WORD{'ground\s*based'} = "ground_based"; 
$COMPOUND_WORD{'globular\s*cluster'} = "globular_cluster";
$COMPOUND_WORD{'hard\s*xray'} = "hard_xray";
$COMPOUND_WORD{'hii\s*region'} = "hii_region";
$COMPOUND_WORD{'high\s*energy\s*astrophysics'} = "high_energy_astrophysics";
#$COMPOUND_WORD{'high\s*energy'} = "high_energy";
$COMPOUND_WORD{'high\s*resolution'} = "high_resolution";
$COMPOUND_WORD{'hot\s*star'} = "hot_star"; 
$COMPOUND_WORD{'^hubble$'} = "hubble_space_telescope";
$COMPOUND_WORD{'hubble\s*space\s*telescope'} = "hubble_space_telescope";
$COMPOUND_WORD{'interstellar\s*gas'} = "interstellar_gas";
$COMPOUND_WORD{'interstellar\s*matter'} = "interstellar_matter";
$COMPOUND_WORD{'interstellar\s*molecules'} = "interstellar_molecules";
$COMPOUND_WORD{'interstellar\s*medium'} = "interstellar_medium";
$COMPOUND_WORD{'large\s*magellanic'} = "large_magellanic";
$COMPOUND_WORD{'late\s*type\s*gal'} = "latetype_gal"; 
$COMPOUND_WORD{'late\s*type\s*star'} = "latetype_star"; 
$COMPOUND_WORD{'light\s*curve'} = "light_curve";
$COMPOUND_WORD{'light\s*pollution'} = "light_pollution";
$COMPOUND_WORD{'low\s*resolution'} = "low-resolution";
$COMPOUND_WORD{'lyman\s*alpha'} = "lyman_alpha";
$COMPOUND_WORD{'magnetic\s*field'} = "magnetic_field";
$COMPOUND_WORD{'magnetospheric\s*physic'} = "magnetospheric_physic";
$COMPOUND_WORD{'magellanic\s*cloud'} = "magellanic_cloud";
$COMPOUND_WORD{'medium\s*resolution'} = "medium-resolution";
$COMPOUND_WORD{'metal\s*poor'} = "metal_poor";
$COMPOUND_WORD{'milky\s*way'} = "milky_way";
$COMPOUND_WORD{'molecular\s*cloud'} = "molecular_cloud";
$COMPOUND_WORD{'molecular\s*hydrogen'} = "molecular_hydrogen";
$COMPOUND_WORD{'name\s*resolver'} = "name_resolver";
$COMPOUND_WORD{'national\s*virtual\s*observatory'} = "national_virtual_observatory";
$COMPOUND_WORD{'near\s*earth'} = "near_earth";
$COMPOUND_WORD{'near\s*i[n|r]f?'} = "near_infrared";
$COMPOUND_WORD{'neutral\s*hydrogen'} = "neutral_hydrogen";
$COMPOUND_WORD{'neutron\s*star'} = "neutron_star";
$COMPOUND_WORD{'numerical\s*sim'} = "numerical_sim";
$COMPOUND_WORD{'ob\s*ass'} = "ob_ass";
$COMPOUND_WORD{'observational\s*a'} = "observational_a";
$COMPOUND_WORD{'objective\s*prism'} = "objective_prism";
$COMPOUND_WORD{'open\s*cluster'} = "open_cluster";
$COMPOUND_WORD{'open\s*skynode'} = "open_skynode";
$COMPOUND_WORD{'peculiar\s*star'} = "peculiar_star";
$COMPOUND_WORD{'point\s*source'} = "point_source";
$COMPOUND_WORD{'photographic\s*plate'} = "photographic_plate";
$COMPOUND_WORD{'photodissociation\s*region'} = "photodissociation_region";
$COMPOUND_WORD{'planetary\s*neb'} = "planetary_neb";
$COMPOUND_WORD{'planetary\s*ast'} = "planetary_ast";
$COMPOUND_WORD{'planetary\s*sys'} = "planetary_sys";
$COMPOUND_WORD{'proper\s*motion'} = "proper_motion";
$COMPOUND_WORD{'redshift\s*distance'} = "redshift_distance";
$COMPOUND_WORD{'reference\s*frame'} = "reference_frame";
$COMPOUND_WORD{'relative\s*position'} = "relative_position";
$COMPOUND_WORD{'reference\s*system'} = "reference_system";
$COMPOUND_WORD{'richardson\s*lucy'} = "richardson_lucy";
$COMPOUND_WORD{'rv\s*tau\s*s'} = "rv_tau_s";
$COMPOUND_WORD{'satellite\s*astronomy'} = "space_astronomy";
$COMPOUND_WORD{'schmidt\s*telescope'} = "schmidt_telescope";
$COMPOUND_WORD{'sky\s*survey'} = "sky_survey";
$COMPOUND_WORD{'sloan\s*d?i?g?i?t?a?l?\s*s?k?y?\s*s?u?r?v?e?y?'} = "ssds--sky_survey";
$COMPOUND_WORD{'small\s*magellanic'} = "small_magellanic";
$COMPOUND_WORD{'spectral\s*energy\s*dist'} = "spectral_energy_dist";
$COMPOUND_WORD{'spectroscopic\s*binary'} = "spectroscopic_binary";
$COMPOUND_WORD{'space\s*based\s*astronomy'} = "space_astronomy";
$COMPOUND_WORD{'space\s*ast'} = "space_ast";
$COMPOUND_WORD{'space\s*physics'} = "space_physics";
$COMPOUND_WORD{'space\s*plasma'} = "space_plasma";
$COMPOUND_WORD{'soft\s*xray'} = "soft_xray";
$COMPOUND_WORD{'solar\s*ast'} = "solar_ast";
$COMPOUND_WORD{'solar\s*flare'} = "solar_flare";
$COMPOUND_WORD{'solar\s*physics'} = "solar_physics";
$COMPOUND_WORD{'solar\s*system'} = "solar_system";
$COMPOUND_WORD{'solar\s*wind'} = "solar_wind";
$COMPOUND_WORD{'spectral\s*line'} = "spectral_line";
$COMPOUND_WORD{'stellar\s*atmospheres?'} = "stellar_atmosphere";
$COMPOUND_WORD{'stellar\s*content'} = "stellar_content";
$COMPOUND_WORD{'stellar\s*spect'} = "star--spect";
$COMPOUND_WORD{'stellar\s*lines?'} = "star--line";
$COMPOUND_WORD{'star\s*spectra'} = "star--spectra";
$COMPOUND_WORD{'star\s*clusters?'} = "star_cluster";
$COMPOUND_WORD{'star\s*formation'} = "star_formation";
$COMPOUND_WORD{'strong\s*gravitational[\s]*lense?s?'} = "strong_gravitational_lens"; 
$COMPOUND_WORD{'super\s*novae?\s*remnants?'} = "supernova_remnant";
$COMPOUND_WORD{'surface\s*photo'} = "surface_photo";
$COMPOUND_WORD{'system\s*component'} = "system_component";
$COMPOUND_WORD{'transmission\s*gratings?'} = "transmission_grating";
$COMPOUND_WORD{'to\s*be\s*done'} = "to_be_done";
$COMPOUND_WORD{'variable\s*star'} = "variable_star";
$COMPOUND_WORD{'velocity[\-|\s]*moments?'} = "velocity_moment";
$COMPOUND_WORD{'^virtual\s*observator'} = "virtual_observator";
$COMPOUND_WORD{'weak\s*gravitational\s*lens'} = "weak_gravitational_lens"; 
$COMPOUND_WORD{'web\s*application'} = "web_application";
$COMPOUND_WORD{'white\s*dwarf'} = "white_dwarf";
$COMPOUND_WORD{'\w!uv'} = "ultraviolet";
$COMPOUND_WORD{'x\s+ray'} = "xray";

# well-known astronomy specific acronym (& acryonyms) which may lead or
# (sometimes) trail a term
my %ACRONYM_WORD;
$ACRONYM_WORD{'^a1\-?([\W|\w]+)$'} = "a1";
$ACRONYM_WORD{'^a2\-?([\W|\w]+)$'} = "a2";
$ACRONYM_WORD{'^a4\-?([\W|\w]+)$'} = "a4";
$ACRONYM_WORD{'^asca\-?([\W|\w]+)$'} = "asca";
$ACRONYM_WORD{'^agns?\-?([\W|\w]*)$'} = "active_galactic_nucleus";
$ACRONYM_WORD{'^batse\-?([\W|\w]+)$'} = "batse";
$ACRONYM_WORD{'^bbxrt\-?([\W|\w]+)$'} = "bbxrt";
$ACRONYM_WORD{'^chandra\-?([\W|\w]+)$'} = "chandra";
$ACRONYM_WORD{'^cat$'} = "catalog";
$ACRONYM_WORD{'^cv\-?([\W|\w]*)$'} = "cataclysmic_variable";
$ACRONYM_WORD{'^egret\-?([\W|\w]+)$'} = "egret";
$ACRONYM_WORD{'^euve\-?([\W|\w]+)$'} = "extreme_ultraviolet_explorer";
$ACRONYM_WORD{'^euvi\-?([\W|\w]+)$'} = "secchi_extreme_ultraviolet_imager";
$ACRONYM_WORD{'^fuse[\s|\-]?([\W|\w]+)$'} = "fuse";
$ACRONYM_WORD{'^fuv\-?([\W|\w]*)$'} = "farultraviolet";
$ACRONYM_WORD{'^ginga\-?([\W|\w]+)$'} = "ginga";
$ACRONYM_WORD{'^grbs?[\s|\-]?([\W|\w]*)$'} = "burst--gamma_ray";
$ACRONYM_WORD{'^hessi\-?([\W|\w]+)$'} = "reuven_ramaty_high_energy_solar_spectroscopic_imager";
$ACRONYM_WORD{'^hete2\-?([\W|\w]+)$'} = "high_energy_transient_explorer";
$ACRONYM_WORD{'^hmxbs?[\s|\-]?([\W|\w]*)$'} = "high_mass_xray_binary";
$ACRONYM_WORD{'^hri\-?([\W|\w]+)$'} = "high_resolution_imager";
$ACRONYM_WORD{'^hst[\s|\-]?([\W|\w]+)$'} = "hubble_space_telescope";
$ACRONYM_WORD{'^integral\-?([\W|\w]*)$'} = "international_gamma_ray_astrophysics_laboratory";
$ACRONYM_WORD{'^iras\-?([\W|\w]+)$'} = "iras";
# unfortunately "int" starts many words, so we can only 
# handle this IF we have a dash or space..
$ACRONYM_WORD{'^int[\-|\s]+([\W|\w]+)$'} = "issac_newton_telescope";
$ACRONYM_WORD{'^ipc\-?([\W|\w]+)$'} = "ipc";
$ACRONYM_WORD{'^iue[\-|\s]?([\W|\w]*)$'} = "international_ultraviolet_explorer";
$ACRONYM_WORD{'^lmc\-?([\W|\w]+)$'} = "large_magellanic_cloud";
$ACRONYM_WORD{'^lmxbs?[\s|\-]?([\W|\w]*)$'} = "low_mass_xray_binary";
$ACRONYM_WORD{'^mdi[\-|\s]?([\W|\w]*)$'} = "michelson_doppler_imager";
$ACRONYM_WORD{'^osse[\-|\s]?([\W|\w]*)$'} = "oriented_scintillation_spectrometer_experiment";
$ACRONYM_WORD{'^oso(\d)[\s|\-]?([\W|\w]*)$'} = "orbiting_solar_observatory";
$ACRONYM_WORD{'^qsos?[\s|\-]?([\W|\w]*)$'} = "quasi_stellar_object";
$ACRONYM_WORD{'^rhessi[\-|\s]?([\W|\w]*)$'} = "reuven_ramaty_high_energy_solar_spectroscopic_imager";
$ACRONYM_WORD{'^rosat\-?([\W|\w]+)$'} = "rosat";
$ACRONYM_WORD{'^rxte[\-|\s]?([\W|\w]*)$'} = "rossi_xray_timing_explorer";
$ACRONYM_WORD{'^sax[\-|\s]?([\W|\w]*)$'} = "beppo_sax";
$ACRONYM_WORD{'^sdss[\s|\-]?([\W|\w]*)$'} = "ssds--sky_survey";
$ACRONYM_WORD{'^seti[\-|\s]?([\W|\w]*)$'} = "search_for_extraterrestrial_intelligence";
$ACRONYM_WORD{'^smc\-?([\W|\w]+)$'} = "small_magellanic_cloud";
$ACRONYM_WORD{'^snr[\-|\s]?([\W|\w]*)$'} = "supernova_remnant";
$ACRONYM_WORD{'^soho\s*([\W|\w]*)$'} = "solar_heliospheric_observatory";
$ACRONYM_WORD{'^swift\s*([\W|\w]+)$'} = "swift";
$ACRONYM_WORD{'^tbd$'} = "to_be_done";
$ACRONYM_WORD{'^time\s*series([\W|\w]*)$'} = "time_series";
$ACRONYM_WORD{'^uv[\-|\s]?([\W|\w]*)$'} = "ultraviolet";
# unfortunately "vo" starts many words, so we can only 
# handle this IF we have a dash or space..
$ACRONYM_WORD{'^vo$'} = "virtual_observatory";
$ACRONYM_WORD{'^vla[\-|\s]?([\W|\w]*)$'} = "very_large_array";
$ACRONYM_WORD{'^wcs$'} = "world_coordinate_system";
$ACRONYM_WORD{'^wfc[\-|\s]?([\W|\w]*)$'} = "wide_field_camera";
$ACRONYM_WORD{'^xmm\-?([\W|\w]+)$'} = "xray_multi_mirror_mission";
$ACRONYM_WORD{'^xte\-?([\W|\w]+)$'} = "rossi_xray_timing_explorer";
$ACRONYM_WORD{'^xuv\-?([\W|\w]*)$'} = "extremeultraviolet";
$ACRONYM_WORD{'^wr$'} = "wolf_rayet";
$ACRONYM_WORD{'^ysos?$'} = "young_stellar_object";

my $SPLIT_DASHED_TERMS_INTO_TOKENS = 0;
my $DEBUG = 0;
my $CHATTY = 0;
my $REPORT_STATS = 0;
my %SUBJECTS;

my $SENTENCES_IGNORED = 0;
my $NROF_STRING_SPLIT = 0;
my $NROF_NON_SPACE_DELIMITED = 0;
#my $NROF_SYNONYMS = 0;
my %PLURAL;
my $NROF_USED_COMPOUND_WORD = 0;

sub setSplitDashedTerms($) { $SPLIT_DASHED_TERMS_INTO_TOKENS = shift; }
sub setReportStats($) { $REPORT_STATS = shift; }
sub setChatty ($) { $CHATTY = shift; }
sub setDebug ($) { $DEBUG = shift; }

sub run_on_file ($) 
{
  my ($file) = @_;

  open(FILE, "$file");
  my %subjects = run_on_list(<FILE>);
  close FILE;

  return %subjects;
}

sub run_on_list ($) 
{
  my (@list) = @_;

  # clear list
  _clearSubjects();

  foreach my $line (@list) 
  {
    print STDERR "line:[$line]\n" if $DEBUG;
    my @subj = &tokenize($line);
    print STDERR "yeilds TOKEN:[",join ',', @subj,"]\n" if $DEBUG;
    &_add_subjects(@subj);
  }

  if ($DEBUG) {
    foreach my $subject (keys %SUBJECTS) { print STDOUT "SUBJECT: $subject\n"; }
  }

  %SUBJECTS = &_fix_synonyms_in_list(\%SUBJECTS);

  if ($DEBUG) {
    print STDERR "AFTER FIX SYNS, list is:\n";
    foreach my $subject (keys %SUBJECTS) { print STDOUT "SUBJECT: $subject\n"; }
  }

  if ($REPORT_STATS) {
    print STDERR "$SENTENCES_IGNORED sentences ignored by tokenizer\n";
    print STDERR "$NROF_NON_SPACE_DELIMITED terms found to be non-space delimited by tokenizer\n";# if $CHATTY;
    print STDERR "$NROF_STRING_SPLIT strings split by spaces by tokenizer\n";# if $CHATTY;
    my @plural_words = keys %PLURAL;
    print STDERR $#plural_words," unique words were plural case and changed to singular\n";# if $CHATTY;
#    print STDERR $NROF_SYNONYMS," words were synonyms and changed \n";# if $CHATTY;
    print STDERR $NROF_USED_COMPOUND_WORD," compound terms with spaces or dashes used\n";# if $CHATTY;
  }

  #my %counts = ();
  #foreach my $str_count (keys %subjects) { $counts{int $str_count} = $str_count; }
  #foreach my $count ( sort {$a <=> $b} keys %counts) { foreach $s (@{$subjects{$count}}) { print $s, " "; } print " ($count)\n"; } 

  return %SUBJECTS;
}

sub _clearSubjects() { %SUBJECTS = (); }

sub _find_synonyms_in_list ($$) {
  my ($term, $list_ref) = @_;

  my %list = %{$list_ref};

  if ($term =~ m/\:/i) {
    my $new_term = _convert_colon_term($subject);
    return $new_term if (exists $list{$new_term});
  }

  if ($term =~ m/\-\-/i) 
  {
      #my @terms = split '--', $term;
      my @terms = &_split_string_using_delimiter('--',$str);
      return join '_' if (exists $list{join '_', @terms});
      return join '' if (exists $list{join '', @terms});
  }

  if($term =~ m/^([\W|\w]+)_([\W|\w]+)$/i)
  {
    my $new_term = $1.$2; 
    return $new_term if (exists $list{$new_term});
  }

  return undef;
}

sub _fix_synonyms_in_list ($) {
  my ($list_ref) = @_;
  
  my %list = %{$list_ref};

  # pass 1: take care of colon subjects, converting them
  # to a format we accept, and adding them if they don't exist
  foreach my $subject (keys %list) {
     if ($subject =~ m/\:/i) {
        my $new_subject = _find_synonyms_in_list($subject,\%list);
        if (defined $new_subject) { delete $list{$subject}; }
        else { 
          $new_subject = _convert_colon_term($subject);
          $list{$new_subject} = 1; 
        }
        #if (exists $list{$new_subject}) { delete $list{$subject}; }
        #else { $list{$new_subject} = 1; }
     }
  }

  # pass 2 : fix dash-dash subjects, either breaking them up
  # and adding them if they dont already exist in a variety
  # of possible forms.
  if ($SPLIT_DASHED_TERMS_INTO_TOKENS) 
  {
    foreach my $subject (keys %list) 
    {
      if ($subject =~ m/\-\-/i) 
      {
        my $new_subject = _find_synonyms_in_list($subject,\%list);
        if (!defined $new_subject) 
        {
           my @terms = split '--', $subject;
           foreach my $term (@terms) { $list{$term} = 1 unless (exists $list{$term}); }
        }
        delete $list{$subject};
      }
    }
  }

  # pass3: try seeing if underscore terms match existing
  # ones in the list which lack underscore. If they do,
  # then we remove the underscore term in favor of the new
  # one
  foreach my $subject (keys %list) 
  {
     if($subject =~ m/_/i)
     {
        my $new_subject = _find_synonyms_in_list($subject,\%list);
        if (defined $new_subject) { delete $list{$subject}; }
     }
  }

  return %list;
}

sub tokenize($) {
  my ($str) = @_;
  my @tokens;

  # trim off meaningless leading and trailing whitespace
  $str =~ s/^\s+//g; $str =~ s/\s+$//g;

  print STDERR "TOKENIZE:[$str]\n" if $DEBUG;

  # semi-colons denote separate items
  if (&_is_a_sentence($str))
  {
     return @tokens; 
  }
  elsif (defined (my $new_terms = &_is_a_acronym_word($str)))
  {
     my @terms = @$new_terms;
     foreach my $term (@terms) { 
        if (defined $term)
        {
           push @tokens, &tokenize ($term);
        }
     }
  }
  elsif ($str =~ m/;/i) 
  {
     $NROF_NON_SPACE_DELIMITED += 1;
     my @words = &_split_string_using_delimiter(';',$str);
     foreach my $n (@words) 
     {
        push @tokens, &tokenize ($n);
     }
  } 
  # commas denote separate items
  elsif ($str =~ m/,/i) 
  {
     $NROF_NON_SPACE_DELIMITED += 1;
     my @words = &_split_string_using_delimiter(',',$str);
     foreach my $n (@words) 
     {
        push @tokens, &tokenize ($n);
     }
  } 
  # plus sign denotes separate items
  elsif ($str =~ m/\+/i) 
  {
     $NROF_NON_SPACE_DELIMITED += 1;
     my @words = &_split_string_using_delimiter('\+',$str);
     foreach my $n (@words) 
     {
        push @tokens, &tokenize ($n);
     }
  } 
  # drop slash chars which mess up formatting
  elsif ($str =~ m/^([\w|\W]+)\s*[\/|\\]\s*([\w|\W]+)$/i) 
  {
     my $new_word = &AstroSemantics::TextProcessing::make_singular($1) . &AstroSemantics::TextProcessing::make_singular($2);
     push @tokens, &tokenize ($new_word);
  }
  # deal with colons, sometimes a space separates what are supposed to be
  # as single 'word' like ("stars: binary")
  elsif ($str =~ m/^([\w|\W]+)\:\s+([\w|\W]+)$/i) 
  {
       print STDERR "word has a colon-space sequence in it => ",$str,"\n" if $DEBUG;
       my $new_word = $1. ":" . $2;
       push @tokens, &tokenize ($new_word);
  }
  elsif (defined (my $new_word = &_check_split_compound_word($str)))
  {
      push @tokens, &tokenize ($new_word);
  }
  # we can't handle stuff with numbers leading the id..
  # so we prepend an underscore
  elsif ($str =~ m/^(\d+)([\D|\d]*)/i) 
  {
     print STDERR "GOT NUMBER leading TOKEN: $str\n" if $DEBUG;
     my $new_word = "_";
     $new_word .=  $1; $new_word .=  $2 if defined $2;
     push @tokens, &tokenize ($new_word); 
  }
  # cant handle parens either
  elsif ($str =~ m/^([\W|\w]*)([\(|\)])([\W|\w]*)/i) 
  {
     my $new_word;
     $new_word .=  $1 if defined $1; $new_word .=  $3 if defined $3;
     push @tokens, &tokenize ($new_word); 
  }
  elsif ($str =~ m/\:/i) 
  {
    push @tokens, &tokenize (&_convert_colon_term($str));
  }
  elsif ($str =~ m/^([\W\w]*)\.+([\W\w]*)$/i)
  {
     # remove periods
     push @tokens, &tokenize($1.$2);
  }
  elsif ($str =~ m/^([\W\w]+)-([\W\w]+)$/i && $1 !~ m/-/i)
  {
     # remove single dashes 
     push @tokens, &tokenize($1.$2);
  }
  # a few spaces denote separate items,
  # many spaces (more than 3) probably mean a sentence.. 
  # furthermore, if this has a colon in it, we should avoid
  # splitting it
  elsif ( $str =~ m/(\s+)/i
            and 
          $str !~ m/\:/i
        ) 
  {
    $NROF_STRING_SPLIT += 1;
    my $new_word = "";
    my @words = &_split_string_using_delimiter(' ',$str);

    # FOR now, treat everything as set of associated terms, use '--' to 
    # create the sub-class

    my $cnt = 0;
    foreach my $n (uniq sort {lc($a) cmp lc($b) } @words)
    {
       next if (!defined $n);
       $new_word .= "--" unless $cnt == 0;
       $new_word .= join '', &tokenize($n); 
       $cnt++;
    }

    push @tokens, &tokenize($new_word) if $new_word;

  }
  # Remove 'meaningless' words here, such as 'the', 'and', etc..
  elsif (&_is_a_subject_term($str)) 
  {
     my $final_token = lc &AstroSemantics::TextProcessing::make_singular($str);
     $final_token = _convert_term_to_american_english($final_token);
     push @tokens, "$final_token"; 
  }

  #return @tokens;
  my @unique_tokens = (uniq sort {lc($a) cmp lc($b) } @tokens);
  print STDERR "TOKENIZER RETURN: ",join ' ',@unique_tokens,"\n" if $CHATTY;
  return @unique_tokens;

}

sub _split_string_using_delimiter ($$) {
   my ($delimit, $str) = @_;
   my @words;

   print STDERR "SPLIT String:[$str] using:[$delimit]\n" if $CHATTY;

   my $adj_str="";
   return @words unless defined $str and $str ne "";

   foreach my $word (split $delimit, $str) {
      if (_is_an_adjective($word)) 
      { 
         $adj_str .= $word;
      }
      else 
      {
         if (&_is_a_subject_term($word))
         {
            if ($adj_str ne "") {
               $word = $adj_str."_". $word;
               $adj_str = "";
            }
            push @words, $word;
         }
      }
   }
   return @words;
}

sub _is_a_acronym_word ($) {
  my ($str) = @_;

  foreach my $pattern (keys %ACRONYM_WORD) 
  {
      if ($str =~ m/$pattern/i)
      {
         my @terms;
         if (defined $2) {
            push @terms, $ACRONYM_WORD{$pattern}.$1;
            push @terms, $2;
         } else {
            push @terms, $ACRONYM_WORD{$pattern};
            push @terms, $1 if defined $1;
         }
         print STDERR "ACRONYM matched, got separate terms:[",join ',',@terms,"]\n" if $DEBUG;
         return \@terms;
      }
  }
  return undef;
}

sub _check_split_compound_word($) {
  my ($str) = @_;
  my $pattern;

  print STDERR "CHECK COMPOUND WORD $str \n" if $CHATTY;
  foreach my $pattern (keys %COMPOUND_WORD) 
  {

      #print STDERR "CHECK COMPOUND WORD $str :$pattern\n";

      if ($str =~ m/^([\W|\w]*)$pattern([\W|\w]*)$/i)
      {
         my $new_word = $1. $COMPOUND_WORD{$pattern} . $2;
         print STDERR "GOT COMPOUND WORD :[$str] => [$new_word]\n" if $DEBUG;
         $NROF_USED_COMPOUND_WORD += 1; 

         $new_word = &AstroSemantics::TextProcessing::make_singular($new_word);
         print STDERR " becomes [$new_word]\n" if $DEBUG;
         return $new_word;
#return &AstroSemantics::TextProcessing::make_singular($new_word);
      }
  }

  return undef;
}

sub _is_a_sentence($) {
  my ($str) = @_;

  print STDERR "Check IS a Sentence:$str\n" if $CHATTY;
  my @num_of_commas = split ',', $str;
  my @words = &_split_string_using_delimiter(' ',$str);

  if (($#words > 4 and $#num_of_commas < 3) ) { #or ($#words > -1 and $words[$#words] =~ m/.*\.$/)) {
     print STDERR "WARNING: cannot tokenize possible sentence:[$str]\n" if $CHATTY;
     $SENTENCES_IGNORED += 1;
     return 1;
  }
  return 0;
} 

# we use this to cull out words which don't have much
# likelyhood of creating a subject for us 
# This is simplistic, as obviously, we are throwing out
# meaning here, particularly with some conjuctions 
#
sub _is_a_subject_term($) 
{
  my ($str) = @_;

#  return 0 if _is_a_sentence($str);

  return 0 if _is_a_conjunction ($str);
  return 0 if _is_a_preposition($str);
  return 0 if _is_a_demonstrative_adjective($str);

  return 1 if _is_an_adjective($str);
#  return 1 if _is_an_adverb($str);
#  return 1 if _is_a_noun($str);
#  return 1 if _is_a_verb($str);

  if (lc $str eq 'a') { return 0; }

  return 1;
}

# TODO: Use the dictionary
sub _is_a_conjunction ($) 
{
  my ($str) = @_;

  if (lc $str eq 'and') { return 1; }
  elsif (lc $str eq 'but') { return 1; }
  elsif (lc $str eq 'or') { return 1; }
  elsif (lc $str eq 'so') { return 1; }

  return 0;
}

# TODO: Use the dictionary
sub _is_a_preposition($) 
{
  my ($str) = @_;

  if (lc $str eq 'across') { return 1; } 
  elsif (lc $str eq 'at') { return 1; }
  elsif (lc $str eq 'between') { return 1; }
  elsif (lc $str eq 'by') { return 1; }
  elsif (lc $str eq 'of') { return 1; }
  elsif (lc $str eq 'for') { return 1; }
  elsif (lc $str eq 'in') { return 1; }
  elsif (lc $str eq 'on') { return 1; }
  elsif (lc $str eq 'near') { return 1; }
  elsif (lc $str eq 'to') { return 1; }
  elsif (lc $str eq 'over') { return 1; }
  elsif (lc $str eq 'under') { return 1; }
  elsif (lc $str eq 'with') { return 1; }

  return 0;
}

sub _is_a_demonstrative_adjective($) 
{
  my ($str) = @_;

  if (lc $str eq 'the') { return 1; } 
  return 0;

}

# TODO: Use the dictionary
sub _is_an_adjective($) {
  my ($s) = @_;
  
  if (lc $s eq "astronomical") { return 1; } 
  elsif (lc $s eq "cataclysmic") { return 1; } 
  elsif (lc $s eq "eclipsing") { return 1; } 
  elsif (lc $s eq "spectroscopic") { return 1; } 

  return 0;
}

sub _convert_term_to_american_english($) {
  my ($str) = @_;

  foreach my $pattern (keys %AMERICAN_ENGLISH)
  {

      if ($str =~ m/^([\W|\w]*)$pattern([\W|\w]*)$/i)
      {
         my $new_str = $1. $AMERICAN_ENGLISH{$pattern} . $2;
         return &AstroSemantics::TextProcessing::make_singular($new_str);
      }
  }
  return $str;
}

# colon terms like "star:binary" may be reversed
# in cases to match an existing term, like "binary_star"
# In those cases where they don't match, then simply
# split the term appart
sub _convert_colon_term($) {
  my ($s) = @_;

  if ($s =~ m/^([\W|\w]+)\:([\W|\w]+)$/) {

    my $first = &AstroSemantics::TextProcessing::make_singular($1);
    my $second = &AstroSemantics::TextProcessing::make_singular($2);
    print STDERR "COLON TERM:$s with parts ($first)($second)\n" if $CHATTY;
    if (defined (my $new_word = &_check_split_compound_word($second." ".$first)))
    {
       return $new_word;
    }
    elsif (defined (my $new_word2 = &_check_split_compound_word($first." ".$second)))
    {
       return $new_word2;
    }
    else 
    {
       my $new = join '', &tokenize ($second);
#       $new .= "--" ; 
       $new .= " " ; 
       $new .= join '', &tokenize ($first);
       print STDERR "RETURNING COLON TERM:$new\n" if $CHATTY;
       return $new; 
    }
  }
  return $s;
}

sub _add_subjects($) {
  my @s = @_;

  foreach my $subject (@s) {
    print STDERR "Add subject to list:",$subject,"\n" if $DEBUG;
    my $subj = &AstroSemantics::TextProcessing::make_singular($subject); 
    $subj = lc $subj;
    print STDERR "FINAL subject to list:",$subj,"\n" if $DEBUG;
    if (!$SUBJECTS{"$subj"})
    {
      $SUBJECTS{"$subj"} = 1
    } else {
      $SUBJECTS{"$subj"} += 1;
    }
  }

}

1;
