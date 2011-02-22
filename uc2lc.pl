#!/usr/bin/perl -w

use warnings;
use XML::LibXML;

# get configuration file name as parameter.
my $xml_fname = shift;
my $imp_version = shift;

# parse the configuration file.
my $parser = XML::LibXML->new();
my $doc = $parser->parse_file($xml_fname);
	
# recursivly process the file.
my $depth = 0;
&proc_node($doc->getDocumentElement);

sub proc_node {
	$node = shift;
	
	# in case of text node, check if it's a file name, and if it is do the following:
	# 1. rename the file name to be with lowercase.
	# 2. replace backslash "\" with slash "/"
	# 3. replace spaces with underscore.
	if ( $node->nodeType eq &XML_TEXT_NODE ){
		my $text = $node->data;
		#if ( $text =~ m/^d:\\infogin\\/ ){ # it is a configuration file if it start with "d:\infogin\"
		if ( $text =~ m/^d:\\.*/ ){ # it is a configuration file if it start with "d:\infogin\"
			$text =~ tr/A-Z \\/a-z_\//;
			$node->setData($text);
		}	
		return;
	}
	# unless it's an element ignore it.
	return unless( $node->nodeType eq &XML_ELEMENT_NODE );

	# make the node name to be with lowercase.
	my $node_name = $node->nodeName;
	$node_name =~ tr/A-Z/a-z/;
	$node->setNodeName($node_name);

	# make the attributes names to be with lowercase.
	my @attr_list = $node->attributes();
	foreach my $attr(@attr_list) {
		if ( $attr->nodeType == &XML_ATTRIBUTE_NODE	) {
			my $attr_name = $attr->nodeName;
			$attr_name =~ tr/A-Z/a-z/;
			$attr->setNodeName($attr_name);
			if ( $depth == 1 && $attr_name eq "version" ){
				$attr->setValue($imp_version);
			}
		}
	}
	
	# recursivly called the next nodes.
	foreach my $child($node->getChildnodes) {
		$depth++;
		&proc_node($child);
		$depth--;
	}
}

# override the configuration file with all the changes.
$doc->toFile($xml_fname, 1);

