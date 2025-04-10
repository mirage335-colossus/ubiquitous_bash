
# NOTICE: Strongly recommended to subsequently add autogenerated annotation to improve Retrieval-Augmented-Generation (RAG) with _semanticAssist .

_knowledge-ubiquitous_bash() {
    [[ "$objectName" != "ubiquitous_bash" ]] && _stop 1

    _safeRMR "$scriptLocal"/knowledge/ubiquitous_bash
    mkdir -p "$scriptLocal"/knowledge/ubiquitous_bash

    mkdir -p "$scriptLocal"/knowledge/ubiquitous_bash/_lib
    cp -r "$scriptAbsoluteFolder"/_lib/_build-fallback-ops.sh "$scriptLocal"/knowledge/ubiquitous_bash/_lib/


    #mkdir -p "$scriptLocal"/knowledge/ubiquitous_bash/_lib/kit/install/cloud/cloud-init/zRotten/zMinimal
    #cp -r "$scriptAbsoluteFolder"/_lib/kit/install/cloud/cloud-init/zRotten/zMinimal "$scriptLocal"/knowledge/ubiquitous_bash/_lib/kit/install/cloud/cloud-init/zRotten

    mkdir -p "$scriptLocal"/knowledge/ubiquitous_bash/_lib/kit/install/cloud/cloud-init/zRotten/zMinimal
    cp "$scriptAbsoluteFolder"/_lib/kit/install/cloud/cloud-init/zRotten/zMinimal/rotten_install.sh "$scriptLocal"/knowledge/ubiquitous_bash/_lib/kit/install/cloud/cloud-init/zRotten/zMinimal/

    cp -r "$scriptAbsoluteFolder"/_config "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/.github "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/.devcontainer "$scriptLocal"/knowledge/ubiquitous_bash/

    cp -r "$scriptAbsoluteFolder"/ai "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/blockchain "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/build "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/generic "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/hardware "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/instrumentation "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/labels "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/metaengine "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/os "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/queue "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/shortcuts "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/special "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/structure "$scriptLocal"/knowledge/ubiquitous_bash/
    cp -r "$scriptAbsoluteFolder"/virtualization "$scriptLocal"/knowledge/ubiquitous_bash/

    cp "$scriptAbsoluteFolder"/_anchor "$scriptLocal"/knowledge/ubiquitous_bash/
    cp "$scriptAbsoluteFolder"/_anchor.bat "$scriptLocal"/knowledge/ubiquitous_bash/

    cp "$scriptAbsoluteFolder"/lean.py "$scriptLocal"/knowledge/ubiquitous_bash/

    cp "$scriptAbsoluteFolder"/scrap-cygwin.txt "$scriptLocal"/knowledge/ubiquitous_bash/

    cp "$scriptAbsoluteFolder"/license.txt "$scriptLocal"/knowledge/ubiquitous_bash/


    mkdir -p "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp
    cp -r "$scriptAbsoluteFolder"/_local/ubcp/_upstream "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp -r "$scriptAbsoluteFolder"/_local/ubcp/conemu "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp -r "$scriptAbsoluteFolder"/_local/ubcp/overlay "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/

    cp "$scriptAbsoluteFolder"/_local/ubcp/.gitignore "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/agpl-3.0.txt "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/cygwin-portable-installer-config.cmd "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/cygwin-portable-updater.cmd "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/cygwin-portable.cmd "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/gpl-2.0.txt "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/gpl-3.0.txt "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/license.txt "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/README.md "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/ubcp_rename-to-enable.cmd "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/ubcp-cygwin-portable-installer.cmd "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/ubcp.cmd "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/zDANGER-symlinks.txt "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/
    cp "$scriptAbsoluteFolder"/_local/ubcp/zWARNING-path.txt "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/



    cp -r "$scriptAbsoluteFolder"/_doc "$scriptLocal"/knowledge/ubiquitous_bash/

    cp "$scriptAbsoluteFolder"/README.sh.out.txt "$scriptLocal"/knowledge/ubiquitous_bash/


    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/.devcontainer/README.md
    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/build/haskell/README.html
    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/build/haskell/README.md
    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/build/haskell/README.mediawiki.txt
    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/build/haskell/README.pdf
    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/build/haskell/README.sh
    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/build/haskell/README_presentation.html
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/queue/aggregator/README.md
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/README.sh.out.txt
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/_config/README.md
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/_doc/equations-space/README.sh
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/_doc/queue/broadcastPipe/README.md
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/_lib/kit/install/cloud/cloud-init/zRotten/specialized/croc/README.md
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/_lib/kit/install/cloud/cloud-init/zRotten/zMinimal/README.md
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/README.md
    #rm -f "$scriptLocal"/knowledge/ubiquitous_bash/_local/ubcp/_upstream/README.md



    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/ai/dataset/_ref/OBSOLETE-corpus.sh
    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/shortcuts/git/_ref/_scratch-diag*.txt
    rm -f "$scriptLocal"/knowledge/ubiquitous_bash/shortcuts/git/_ref/*OBSOLETE*
}


