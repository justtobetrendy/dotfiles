const bar = {
  // fontFamily: "JetBrainsMono Nerd Font Propo", // this is problematic for single icon bars
  fontFamily: "JetBrainsMono Nerd Font",
  fontSize: 13,
  fontWeight: 700,
  height: 30,
  width: 1280,
  spacing: 2.0
}

const screens = {
  "DP-7": { start: 1, end: 5 },
  "DP-8": { start: 1, end: 5 },
  "eDP-1": { start: 6, end: 10 }
}

const notifications = {
  timeout: 5000
}

const bluelight = {
  temperature: 3500
}

const colors = {
  // mutagen based
  background: "#111418",
  on_background: "#e1e2e8",
  danger: "#ed8796", // red
  // danger: "#f5bde6", // pink
  success: "#a6da95", // green
  warning: "#eed49f", // yellow
  region_selected: "#a6e3a1",
  tile: {
    background: "#1d2024",      // surface_container
    badgeActive: "#504663",     // mauve @ ~30% over surface_container
    badgeInactive: "#363a4f"    // surface0
  },
  slider: {
    handle: "#C6A0F6",     // mauve
    fill: "#C6A0F6",       // mauve
    background: "#363A4F"  // surface0
  },
  notification: {
    bg: "#1a1b26",
    bgDark: "#16161e",
    fg: "#a9b1d6",
    muted: "#444b6a",
    cyan: "#8bd5ca", // teal
    purple: "#c6a0f6", // mauve
    red: "#ed8796", // red
    yellow: "#eed49f", // yellow
    blue: "#8aadf4" // blue
  }

  //     @define-color error #ffb4ab;
  //
  //     @define-color error_container #93000a;
  //
  //     @define-color inverse_on_surface #2e3135;
  //
  //     @define-color inverse_primary #36618e;
  //
  //     @define-color inverse_surface #e1e2e8;
  //
  //
  //     @define-color on_error #690005;
  //
  //     @define-color on_error_container #ffdad6;
  //
  //     @define-color on_primary #003258;
  //
  //     @define-color on_primary_container #d1e4ff;
  //
  //     @define-color on_primary_fixed #001d36;
  //
  //     @define-color on_primary_fixed_variant #194975;
  //
  //     @define-color on_secondary #253140;
  //
  //     @define-color on_secondary_container #d7e3f7;
  //
  //     @define-color on_secondary_fixed #101c2b;
  //
  //     @define-color on_secondary_fixed_variant #3b4858;
  //
  //     @define-color on_surface #e1e2e8;
  //
  //     @define-color on_surface_variant #c3c7cf;
  //
  //     @define-color on_tertiary #3b2948;
  //
  //     @define-color on_tertiary_container #f2daff;
  //
  //     @define-color on_tertiary_fixed #251431;
  //
  //     @define-color on_tertiary_fixed_variant #523f5f;
  //
  //     @define-color outline #8d9199;
  //
  //     @define-color outline_variant #42474e;
  //
  //     @define-color primary #a0cafd;
  //
  //     @define-color primary_container #194975;
  //
  //     @define-color primary_fixed #d1e4ff;
  //
  //     @define-color primary_fixed_dim #a0cafd;
  //
  //     @define-color scrim #000000;
  //
  //     @define-color secondary #bbc7db;
  //
  //     @define-color secondary_container #3b4858;
  //
  //     @define-color secondary_fixed #d7e3f7;
  //
  //     @define-color secondary_fixed_dim #bbc7db;
  //
  //     @define-color shadow #000000;
  //
  //     @define-color source_color #6c7a8d;
  //
  //     @define-color surface #111418;
  //
  //     @define-color surface_bright #36393e;
  //
  //     @define-color surface_container #1d2024;
  //
  //     @define-color surface_container_high #272a2f;
  //
  //     @define-color surface_container_highest #32353a;
  //
  //     @define-color surface_container_low #191c20;
  //
  //     @define-color surface_container_lowest #0b0e13;
  //
  //     @define-color surface_dim #111418;
  //
  //     @define-color surface_tint #a0cafd;
  //
  //     @define-color surface_variant #42474e;
  //
  //     @define-color tertiary #d6bee4;
  //
  //     @define-color tertiary_container #523f5f;
  //
  //     @define-color tertiary_fixed #f2daff;
  //
  //     @define-color tertiary_fixed_dim #d6bee4;
}
