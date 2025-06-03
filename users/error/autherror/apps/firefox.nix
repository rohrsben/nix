{ config, inputs, ... }:

let
    app = "firefox";
    configDir = ./config/${app};
in {
    imports = [
        inputs.textfox.homeManagerModules.default
    ];

    textfox = {
        enable = true;
        profile = "error";
        useLegacyExtensions = false;
        config = {
            font = {
                family = "JetBrainsMono Nerd Font";
            };
            tabs = {
                vertical = {
                    margin = "1.0rem";
                };
            };
        };
    };

    programs.firefox = {
        enable = true;

        policies = {
            # via mozilla.github.io/policy-templates
            DisableFirefoxAccounts = true;
            DisableFirefoxStudies = true;
            DisableFirefoxScreenshots = true;
            PrintingEnabled = false;
            OfferToSaveLogins = false;
            DisablePocket = true;
            DisableProfileImport = true;
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;

            ExtensionSettings = {
                # ublock origin
                "uBlock0@raymondhill.net" = {
                    "installation_mode" = "normal_installed";
                    "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                    "default_area" = "menupanel";
                };

                # gesturefy
                "{506e023c-7f2b-40a3-8066-bc5deb40aebe}" = {
                    "installation_mode" = "normal_installed";
                    "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/gesturefy/latest.xpi";
                    "default_area" = "menupanel";
                };

                # bitwarden
                "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
                    "installation_mode" = "normal_installed";
                    "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
                    "default_area" = "navbar";
                };

                # res
                "jid1-xUfzOsOFlzSOXg@jetpack" = {
                    "installation_mode" = "normal_installed";
                    "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/reddit-enhancement-suite/latest.xpi";
                    "default_area" = "menupanel";
                };

                # everforest-dark theme
                "{c0f86627-5243-4bf4-a522-a41ed12f1737}" = {
                    "installation_mode" = "normal_installed";
                    "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/everforest-dark-official/latest.xpi";
                };
            };
        };

        profiles.error = {
            settings = {
                "extensions.autoDisableScopes" = 0;
            };
            bookmarks = {
                force = true;
                settings = [{
                    toolbar = true;
                    bookmarks = [
                        {
                            name = "rust-book";
                            url = "https://rust-book.cs.brown.edu/";
                        }
                        {
                            name = "june";
                            url = "https://junehomes.com";
                        }
                        {
                            name = "nix";
                            bookmarks = [
                                {
                                    name = "nix packages";
                                    url = "https://search.nixos.org/packages";
                                }
                                {
                                    name = "hm options";
                                    url = "https://home-manager-options.extranix.com";
                                }
                            ];
                        }
                    ];
                }];
            };
        };
    };
}
