{
  programs.wofi = {
    enable = true;
    settings = {
      width = 500;
      mode = "run";
      stylesheet = "style.css";
      prompt = "";
      filter_rate = "200";
      insensitve = true;
      gtk_dark = true;
      term = "foot";
      layer = "overlay";
    };
    style = ''
      window {
      	background-color: rgba(--wofi-rgb-color0,0.85);
      	font-family: "Iosevka Nerd Font";
      	transition: 0.1s ease-in-out;
      	font-size: 140%;
      }
      #input image {
      	color: rgba(0,0,0,0)
      }
      #input {
      	margin-bottom: 20px;
      	margin-left: 100px;
      	margin-right: 100px;
      	margin-top: 15px;
      	border: 3px solid --wofi-color2;
      }
      label {
      	color: --wofi-color7;
      	transition: 0.1s ease-in-out;
      }
      #entry {
      	padding: 5px;
      	padding-left: 15px;
      }
      #entry:selected {
      	background-color: --wofi-color2;
      }
      #outer-box {
      	border: 4px solid --wofi-color2;
      	transition: 0.1s ease-in-out;
      }
    '';
  };
}
