TEMPLATE = aux

INSTALLER = garlic_install

INPUT = $$PWD/config/config.xml $$PWD/packages
garlicinstall.input = INPUT
garlicinstall.output = $$INSTALLER
unix:garlicinstall.commands = /home/niko/Anwendungen/Qt/Tools/QtInstallerFramework/4.4/bin/binarycreator -c $$PWD/config/config.xml -p $$PWD/packages ${QMAKE_FILE_OUT}
win32:garlicinstall.commands = C:\Qt\Tools\QtInstallerFramework\4.4\bin\binarycreator -c $$PWD\config\config.xml -p $$PWD\packages ${QMAKE_FILE_OUT}
garlicinstall.CONFIG += target_predeps no_link combine

QMAKE_EXTRA_COMPILERS += garlicinstall

DISTFILES += \
    packages/com.sagiadinos.garlic.creator/data/content_to_install.txt \
    packages/com.sagiadinos.garlic.creator/meta/agpl-3.0.txt \
    packages/com.sagiadinos.garlic.creator/meta/install.js \
    config/controllerScript.js \
    packages/com.microsoft.vcredist.x64/meta/install.js \
    packages/com.microsoft.vcredist.x64/data/vc_redist.x64.exe \
    packages/com.microsoft.vcredist.x64/meta/package.xml \
    packages/com.sagiadinos.garlic.creator/meta/package.xml
