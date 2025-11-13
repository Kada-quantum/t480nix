{
  lib,
  jdk23,
  maven,
  fetchgit,
  makeDesktopItem,
  copyDesktopItems,
  glib,
  makeWrapper,
  wrapGAppsHook3,
}: let
  jdk = jdk23.override {
    enableJavaFX = true;
  };
in
  maven.buildMavenPackage rec {
    pname = "scenebuilder";
    version = "23.0.0";
    src = fetchgit {
      url = "https://github.com/gluonhq/scenebuilder.git";
      rev = "66546ee05d54187cc742f453f741f4994530281d";
      hash = "sha256-vf1GNqSbe56oHavtroLhBNoqq84qoL+P9ARH+tXklYA=";
    };
    patches = [
      # makes the mvnHash platform-independent
      ./pom-remove-javafx.patch
      # makes sure that maven upgrades don't change the mvnHash
      ./fix-default-maven-plugin-versions.patch
      ./pom-update-deps.patch
    ];
    postPatch = ''
      # set the build timestamp to $SOURCE_DATE_EPOCH
      substituteInPlace app/pom.xml \
          --replace-fail "\''${maven.build.timestamp}" "$(date -d "@$SOURCE_DATE_EPOCH" '+%Y-%m-%d %H:%M:%S')"
    '';
    mvnJdk = jdk;
    mvnParameters = toString [
      "-Dmaven.test.skip"
      "-Dproject.build.outputTimestamp=1980-01-01T00:00:02Z"
    ];
    mvnHash = "sha256-5LW9T3fCmLGewEiTkt2mxJwT9P7twSj/nTZ+q7cagKY=";
    nativeBuildInputs = [
      copyDesktopItems
      glib
      makeWrapper
      wrapGAppsHook3
    ];
    dontWrapGApps = true; # prevent double wrapping
    installPhase = ''
      runHook preInstall
      install -Dm644 app/target/lib/scenebuilder-${version}-SNAPSHOT-all.jar $out/share/scenebuilder/scenebuilder.jar
      install -Dm644 app/src/main/resources/com/oracle/javafx/scenebuilder/app/SB_Logo.png $out/share/icons/hicolor/128x128/apps/scenebuilder.png
      runHook postInstall
    '';
    postFixup = ''
      makeWrapper ${jdk}/bin/java $out/bin/scenebuilder \
        --set GDK_BACKEND x11 \
        --unset GTK_IM_MODULE \
        --add-flags "--add-modules javafx.web,javafx.fxml,javafx.swing,javafx.media" \
        --add-flags "--add-opens=javafx.fxml/javafx.fxml=ALL-UNNAMED" \
        --add-flags "-jar $out/share/scenebuilder/scenebuilder.jar" \
        "''${gappsWrapperArgs[@]}"
    '';
    desktopItems = [
      (makeDesktopItem {
        name = "scenebuilder";
        exec = "scenebuilder";
        icon = "scenebuilder";
        comment = "A visual, drag'n'drop, layout tool for designing JavaFX application user interfaces.";
        desktopName = "Scene Builder";
        mimeTypes = [
          "application/java"
          "application/java-vm"
          "application/java-archive"
        ];
        categories = ["Development"];
      })
    ];
    meta = with lib; {
      changelog = "https://github.com/gluonhq/scenebuilder/releases/tag/${src.rev}";
      description = "Visual, drag'n'drop, layout tool for designing JavaFX application user interfaces";
      homepage = "https://gluonhq.com/products/scene-builder/";
      license = licenses.bsd3;
      mainProgram = "scenebuilder";
      maintainers = with maintainers; [wirew0rm];
      platforms = jdk.meta.platforms;
      sourceProvenance = with sourceTypes; [
        fromSource
        binaryBytecode # deps
      ];
    };
  }
