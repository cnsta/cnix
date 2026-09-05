{
  ashell,
  deltaSrc,
}:
ashell.overrideAttrs (old: {
  pname = "ashell-delta";

  postPatch =
    (old.postPatch or "")
    + ''
      cp ${deltaSrc}/contrib/ashell/delta.rs src/services/compositor/delta.rs

      substituteInPlace src/services/compositor/mod.rs \
        --replace-fail 'pub mod generic;' 'pub mod delta;
      pub mod generic;'

      substituteInPlace src/services/compositor/mod.rs \
        --replace-fail 'CompositorChoice::Generic => generic::run_listener(&tx).await,' \
          'CompositorChoice::Delta => delta::run_listener(&tx).await,
              CompositorChoice::Generic => generic::run_listener(&tx).await,'

      substituteInPlace src/services/compositor/mod.rs \
        --replace-fail 'CompositorChoice::Generic => generic::execute_command(command).await,' \
          'CompositorChoice::Delta => delta::execute_command(command).await,
              CompositorChoice::Generic => generic::execute_command(command).await,'

      substituteInPlace src/services/compositor/mod.rs \
        --replace-fail '} else if generic::is_available() {' \
          '} else if delta::is_available() {
              Some(CompositorChoice::Delta)
          } else if generic::is_available() {'

      substituteInPlace src/services/compositor/types.rs \
        --replace-fail 'Generic,' 'Delta,
      Generic,'
    '';

  meta =
    old.meta
    // {
      description = "ashell with a delta compositor backend";
    };
})
