#!/usr/bin/perl -w

package AstroSemantics::AstroDictionary;
use AstroSemantics::TextProcessing;

# One day, we will store all of this in a database which other
# languages may access. For now, its all coded in hash tables
# in perl (sigh).

my %HYPERNYMS;
# some astronomy words for which we supply specific to broader contexts (hypernyms;
# or in the taxonomy/ontology world "parent classes") in progressively broader scope
#
$HYPERNYMS{'astronomical--image'} = ["image"];
$HYPERNYMS{'astronomicalimage'} = ["image"];
$HYPERNYMS{'astronomy--extragalactic'} = ["astronomy"];
$HYPERNYMS{'astronomy--galactic'} = ["astronomy"];
$HYPERNYMS{'astronomy--history--philosophy'} = ["astronomy--history", "astronomy"];
$HYPERNYMS{'astronomy--infared'} = ["astronomy"];
$HYPERNYMS{'astronomy--optical'} = ["astronomy"];
$HYPERNYMS{'astronomy--radio'} = ["astronomy"];
$HYPERNYMS{'astronomy--ultraviolet'} = ["astronomy"];
$HYPERNYMS{'astronomy--xray'} = ["astronomy"];
$HYPERNYMS{'narrowband--photometry'} = ["photometry"];
$HYPERNYMS{'photometry--wideband'} = ["photometry"];
$HYPERNYMS{'intermediateband--photometry'} = ["photometry"];

$HYPERNYMS{'a1'} = ["heao-1","xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'a2'} = ["heao-1","xray_observatory","gammaray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'a3'} = ["heao-1","xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'a4'} = ["heao-1","gammaray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'ariel3a'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'ariel5'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'asca'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'alma'} = ["radio_observatory","ground-based_observatory","observatory","mission"];
$HYPERNYMS{'batse'} = ["gammaray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'bbxrt'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'carma'} = ["radio_observatory","ground-based_observatory","observatory","mission"];
$HYPERNYMS{'chandra'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'einsteinobservatory'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'egret'} = ["gammaray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'euve'} = ["ultraviolet_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'fuse'} = ["ultraviolet_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'galex'} = ["ultraviolet_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'ginga'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'heao1'} = ["xray_observatory","gammaray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'heao2'} = ["einstein_observatory","xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'heao3'} = ["gammaray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'highresolutionimager'} = ["einstein_observatory","xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'hinode'} = ["space_observatory","observatory","mission"];
$HYPERNYMS{'hipparcos'} = ["space_observatory","observatory","mission", "astrometry", "parallax", "proper_motion"];
$HYPERNYMS{'hubblespacetelescope'} = ["optical_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'iras'} = ["infrared_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'ipc'} = ["space_observatory","observatory","mission"];
$HYPERNYMS{'integral'} = ["gammaray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'iue'} = ["ultraviolet_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'ledas'} = ["mission"];
$HYPERNYMS{'osse'} = ["gammaray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'nasa'} = ["organization", "institution"];
$HYPERNYMS{'noao'} = ["organization", "institution"];
$HYPERNYMS{'nrao'} = ["organization", "institution"];
$HYPERNYMS{'oso'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'rosat'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'sas'} = ["space_observatory","observatory","mission"];
$HYPERNYMS{'spitzer'} = ["infared_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'sloandigitalskysurvey'} = ["optical_observatory","ground-based_observatory","observatory","mission"];
$HYPERNYMS{'swift'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'vela5b'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'xmm'} = ["xray_observatory","space_observatory","observatory","mission"];
$HYPERNYMS{'xte'} = ["xray_observatory","space_observatory","observatory","mission"];

$HYPERNYMS{'bestar'} = ["early-typestar","emissionlinestar","stellar_object", "object"];
$HYPERNYMS{'cataclysmicvariable'} = ["binary_star","nova","stellar_object", "object"];
$HYPERNYMS{'markariangalaxy'} = ["galaxy","object"];
$HYPERNYMS{'star'} = ["stellar_object", "object"];
$HYPERNYMS{'peculiarstar'} = ["stellar_object", "object"];
$HYPERNYMS{'variablestar'} = ["star", "stellar_object", "object"];
$HYPERNYMS{'wr'} = ["wolf_rayet_star","stellar_object","object"];
$HYPERNYMS{'youngstellarobject'} = ["stellar_object","object"];

$HYPERNYMS{'astrogrid'} = ["organization", "institution", "mission"];
$HYPERNYMS{'eurovo'} = ["organization", "institution", "mission"];
$HYPERNYMS{'ivoa'} = ["virtual_observatory","organization", "institution", "mission"];
#$HYPERNYMS{'ivo'} = ["virtual_observatory","organization", "institution", "mission"];
$HYPERNYMS{'nvo'} = ["national_virtual_observatory","virtual_observatory","organization", "institution", "mission"];
$HYPERNYMS{'nationalvirtualobservatory'} = ["virtual_observatory","organization", "institution", "mission"];
$HYPERNYMS{'vao'} = ["virtual_observatory","organization", "institution", "mission"];
#$HYPERNYMS{'vo'} = ["virtual_observatory","organization", "institution", "mission"];
$HYPERNYMS{'internationalvirtualobservatory'} = ["virtual_observatory","organization", "institution", "mission"];
$HYPERNYMS{'virtualobservatory'} = ["virtual_observatory","organization", "institution", "mission"];
 
$HYPERNYMS{'votable'} = ["xml","data_file"];

my %SYNONYMS;
$SYNONYMS{'1d'}= ["one_dimension"]; 
$SYNONYMS{'3d'}= ["three_dimensions"]; 
$SYNONYMS{'?'} = ["??", "???", "unknown"];
$SYNONYMS{''}= ["unknown"];
$SYNONYMS{'atmospherestar'}= ["stellar_atmosphere"]; 
$SYNONYMS{'astronomyvirtual'}= ["virtual_observatory"]; 
$SYNONYMS{'astrophysicsextragalactic'}= ["astronomy--extragalactic"]; 
$SYNONYMS{'astrophysicsstellar'}= ["astronomy.star"]; 
$SYNONYMS{'agn'}= ["active_galactic_nucleus"];
$SYNONYMS{'broadband'} = ["wideband"];
$SYNONYMS{'bllacobject'} = ["bl_lacertae_object"];
$SYNONYMS{'catalogue'} = ["catalog"];
$SYNONYMS{'cataclysmicbinary'} = ["cataclysmic_variable"];
$SYNONYMS{'cataclysmicvariable'} = ["cataclysmic_variable_star"];
$SYNONYMS{'computersimulation'} = ["simulation"];
$SYNONYMS{'cme'} = ["coronal_mass_ejection"];
$SYNONYMS{'cv'} = ["cataclysmic_variable"];
$SYNONYMS{'datarepository'} = ["archive"];
$SYNONYMS{'digitallibrary'} = ["archive"];
$SYNONYMS{'eclipsingbinary'} = ["eclipsing_binary_star"];
$SYNONYMS{'emissionstar'} = ["emission_line_star"];
$SYNONYMS{'extremeuv'} = ["extreme_ultraviolet"];
$SYNONYMS{'globularstarcluster'}= ["globular_cluster"];
$SYNONYMS{'globularcluster'}= ["globular_star_cluster"];
$SYNONYMS{'grb'}= ["gamma-ray_burst"];
$SYNONYMS{'hubble'} = ["hubble_space_telescope"];
$SYNONYMS{'hst'} = ["hubble_space_telescope"];
$SYNONYMS{'ivo'} = ["international_virtual_observatory"];
$SYNONYMS{'ism'} = ["interstellar_medium", "interstellar_matter"];
$SYNONYMS{'interstellarmatter'} = ["interstellar_medium", "ism"];
$SYNONYMS{'interstellarmedium'} = ["interstellar_matter", "ism"];
$SYNONYMS{'lmc'} = ["large_magellanic_cloud"];
$SYNONYMS{'milkyway'} = ["milky_way_galaxy"];
$SYNONYMS{'opencluster'} = ["open_star_cluster"];
$SYNONYMS{'quasistellarobject'} = ["quasar", "qso"];
$SYNONYMS{'qso'} = ["quasar", "quasi_stellar_object"];
$SYNONYMS{'skynode'} = ["open_skynode"];
$SYNONYMS{'smc'} = ["small_magellanic_cloud"];
$SYNONYMS{'spectra'} = ["spectroscopy"];
$SYNONYMS{'spectroscopicbinary'} = ["spectroscopic_binary_star"];
$SYNONYMS{'stellar'} = ["star"];
$SYNONYMS{'wideband'} = ["broadband"];
$SYNONYMS{'wr'} = ["wolf_rayet_star"];
$SYNONYMS{'vo'} = ["virtual_observatory"];
$SYNONYMS{'youngstellarobject'} = ["yso"];

# These are 'cheating', should be handled elsewhere as part
# of the tokenization process
$SYNONYMS{'astronomyvariablestar'}= ["variable_star"]; 
$SYNONYMS{'clustr'}= ["cluster"];
$SYNONYMS{"clustersofgalaxy"} = ["galaxy_cluster"];
$SYNONYMS{'bulgegalaxy'}= ["galactic_bulge"];
$SYNONYMS{'galaxymarkarian'}= ["markarian_galaxy"];
$SYNONYMS{'starspectra'}= ["star.spectroscopy"];
$SYNONYMS{'galaxyspectra'}= ["galaxy.spectroscopy"];
$SYNONYMS{'halogalaxy'}= ["halo_galaxy"];
$SYNONYMS{'marsplanet'}= ["mars"];
$SYNONYMS{'starwhitedwarf'}= ["white_dwarf"];
$SYNONYMS{'starwolfrayet'}= ["wolf_rayet_star"];


sub _initSyns () { my %syns } 

sub getSynonyms($) 
{ 
  my ($term) = @_; 


  my @synonyms;
  my $id = _get_id($term);

  if (defined $id && defined $SYNONYMS{$id}) 
  {
    push @synonyms, @{$SYNONYMS{$id}}; 
  }

  return @synonyms; 

}

sub getHypernyms($) 
{
  my ($term) = @_;

  my @hypernyms;

  my $id = _get_id($term);
  if (defined $id && exists $HYPERNYMS{$id}) { 
     @hypernyms = @{$HYPERNYMS{$id}}; 
  }
  else 
  {
     my @synonyms = getSynonyms($term); 
     foreach my $syn (@synonyms) {
        my $syn_id = _get_id($synonym);
        if (defined $syn_id && exists $HYPERNYMS{$syn_id}) { 
          push @hypernyms, @{$HYPERNYMS{$syn_id}};
        }
     } 
  } 

  return @hypernyms;
}

sub getHyponyms($) { die "AstroDictionary::getHyponyms functionality not implemented yet.\n"; }

# Internal Function to generate consistent Ids from
# input word for purpose of looking up words
sub _get_id ($) {
  my ($val) = @_;

  return $val unless defined $val;

  my $id = AstroSemantics::TextProcessing::getClassId($val); 

  $id =~ s/_//g;
  #$id =~ s/ //g;
  #$id =~ s/\-//g unless ($id =~ m/\-\-/); # "--" is significant, but "-" is not 

  return $id;
}

1;
