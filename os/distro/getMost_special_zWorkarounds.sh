
# NOTICE: Destroying developer functionality on programs made for local use is NEVER an acceptable solution. At minimum such functionality must, for an ephemeral CI environment, still be usable.
#  CAUTION: In this case, the relevant functionality is necessary to create accurate PDF output from PCB designs for integrating electronics with CAD models and for printing and comparing with 3D printed models. Such basic hardware design capability is absolutely NOT something the world can just do without.
# https://www.kb.cert.org/vuls/id/332928/
#  'This issue is addressed in Ghostscript version 9.24. Please also consider the following workarounds:'
#   NO. Using these workarounds, especially on Debian Stable systems which already are up to version 10, which essentially disables all functionality, is completely unacceptable. Such intolerance of developers will NOT be tolerated, and a fork of GhostScript absolutely WILL be maintained if ever necessary.
# https://stackoverflow.com/questions/52998331/imagemagick-security-policy-pdf-blocking-conversion
#  'I believe that the PDF policy was added due to a bug in Ghostscript, which I believe has now been fixed. So it you are using the current Ghostscript, then you should be fine giving this policy read|write rights.'
_get_workarounds_ghostscript_policyXML() {
	
	# ATTRIBUTION: ChatGPT-3.5 2023-11-02 .
	
	# WARNING: May be untested .
	#sudo -n sed -i '/<!-- disable ghostscript format types -->/,/<\/policymap>/d' "$1"
	#echo '</policymap>' | sudo -n tee -a "$1"
	
	sudo -n sed -i '/<policy domain="coder" rights="none" pattern="PS" \/>/d' "$1"
	sudo -n sed -i '/<policy domain="coder" rights="none" pattern="PS2" \/>/d' "$1"
	sudo -n sed -i '/<policy domain="coder" rights="none" pattern="PS3" \/>/d' "$1"
	sudo -n sed -i '/<policy domain="coder" rights="none" pattern="EPS" \/>/d' "$1"
	sudo -n sed -i '/<policy domain="coder" rights="none" pattern="PDF" \/>/d' "$1"
	sudo -n sed -i '/<policy domain="coder" rights="none" pattern="XPS" \/>/d' "$1"
	
	
	sudo -n sed -i '/<\/policymap>/i \  <policy domain="coder" rights="read | write" pattern="PDF" />\n  <policy domain="coder" rights="read | write" pattern="EPS" />\n  <policy domain="coder" rights="read | write" pattern="PS" />' "$1"
}

# No production use. Yet.
_get_workarounds_ghostscript_policyXML_here() {

cat << 'CZXWXcRMTo8EmM8i4d'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policymap [
  <!ELEMENT policymap (policy)*>
  <!ATTLIST policymap xmlns CDATA #FIXED ''>
  <!ELEMENT policy EMPTY>
  <!ATTLIST policy xmlns CDATA #FIXED '' domain NMTOKEN #REQUIRED
    name NMTOKEN #IMPLIED pattern CDATA #IMPLIED rights NMTOKEN #IMPLIED
    stealth NMTOKEN #IMPLIED value CDATA #IMPLIED>
]>
<!--
  Configure ImageMagick policies.

  Domains include system, delegate, coder, filter, path, or resource.

  Rights include none, read, write, execute and all.  Use | to combine them,
  for example: "read | write" to permit read from, or write to, a path.

  Use a glob expression as a pattern.

  Suppose we do not want users to process MPEG video images:

    <policy domain="delegate" rights="none" pattern="mpeg:decode" />

  Here we do not want users reading images from HTTP:

    <policy domain="coder" rights="none" pattern="HTTP" />

  The /repository file system is restricted to read only.  We use a glob
  expression to match all paths that start with /repository:

    <policy domain="path" rights="read" pattern="/repository/*" />

  Lets prevent users from executing any image filters:

    <policy domain="filter" rights="none" pattern="*" />

  Any large image is cached to disk rather than memory:

    <policy domain="resource" name="area" value="1GP"/>

  Use the default system font unless overwridden by the application:

    <policy domain="system" name="font" value="/usr/share/fonts/favorite.ttf"/>

  Define arguments for the memory, map, area, width, height and disk resources
  with SI prefixes (.e.g 100MB).  In addition, resource policies are maximums
  for each instance of ImageMagick (e.g. policy memory limit 1GB, -limit 2GB
  exceeds policy maximum so memory limit is 1GB).

  Rules are processed in order.  Here we want to restrict ImageMagick to only
  read or write a small subset of proven web-safe image types:

    <policy domain="delegate" rights="none" pattern="*" />
    <policy domain="filter" rights="none" pattern="*" />
    <policy domain="coder" rights="none" pattern="*" />
    <policy domain="coder" rights="read|write" pattern="{GIF,JPEG,PNG,WEBP}" />
-->
<policymap>
  <!-- <policy domain="resource" name="temporary-path" value="/tmp"/> -->
  <policy domain="resource" name="memory" value="256MiB"/>
  <policy domain="resource" name="map" value="512MiB"/>
  <policy domain="resource" name="width" value="16KP"/>
  <policy domain="resource" name="height" value="16KP"/>
  <!-- <policy domain="resource" name="list-length" value="128"/> -->
  <policy domain="resource" name="area" value="128MP"/>
  <policy domain="resource" name="disk" value="1GiB"/>
  <!-- <policy domain="resource" name="file" value="768"/> -->
  <!-- <policy domain="resource" name="thread" value="4"/> -->
  <!-- <policy domain="resource" name="throttle" value="0"/> -->
  <!-- <policy domain="resource" name="time" value="3600"/> -->
  <!-- <policy domain="coder" rights="none" pattern="MVG" /> -->
  <!-- <policy domain="module" rights="none" pattern="{PS,PDF,XPS}" /> -->
  <!-- <policy domain="path" rights="none" pattern="@*" /> -->
  <!-- <policy domain="cache" name="memory-map" value="anonymous"/> -->
  <!-- <policy domain="cache" name="synchronize" value="True"/> -->
  <!-- <policy domain="cache" name="shared-secret" value="passphrase" stealth="true"/>
  <!-- <policy domain="system" name="max-memory-request" value="256MiB"/> -->
  <!-- <policy domain="system" name="shred" value="2"/> -->
  <!-- <policy domain="system" name="precision" value="6"/> -->
  <!-- <policy domain="system" name="font" value="/path/to/font.ttf"/> -->
  <!-- <policy domain="system" name="pixel-cache-memory" value="anonymous"/> -->
  <!-- <policy domain="system" name="shred" value="2"/> -->
  <!-- <policy domain="system" name="precision" value="6"/> -->
  <!-- not needed due to the need to use explicitly by mvg: -->
  <!-- <policy domain="delegate" rights="none" pattern="MVG" /> -->
  <!-- use curl -->
  <policy domain="delegate" rights="none" pattern="URL" />
  <policy domain="delegate" rights="none" pattern="HTTPS" />
  <policy domain="delegate" rights="none" pattern="HTTP" />
  <!-- in order to avoid to get image with password text -->
  <policy domain="path" rights="none" pattern="@*"/>
  <!-- disable ghostscript format types -->
  <policy domain="coder" rights="read | write" pattern="PDF" />
  <policy domain="coder" rights="read | write" pattern="EPS" />
  <policy domain="coder" rights="read | write" pattern="PS" />
</policymap>
CZXWXcRMTo8EmM8i4d


}














_get_workarounds_ghostscript_policyXML_write() {
	_get_workarounds_ghostscript_policyXML /etc/ImageMagick-6/policy.xml > /dev/null 2>&1
	_get_workarounds_ghostscript_policyXML /etc/ImageMagick-7/policy.xml > /dev/null 2>&1
}



_get_workarounds() {
	_get_workarounds_ghostscript_policyXML_write "$@"
	
	
}



