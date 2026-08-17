# containers/registry.nix
# Container registry consumed by the flake (Phase 5b/6). Each entry is
# name -> { image = ...; base = ...; rosDistro = ...; cuda = ...; }.
# The flake flattens this to name -> image for the `db` launcher.
{
  ros2-humble.image = "localhost/ros2-humble:latest";
  ros2-kilted.image  = "localhost/ros2-kilted:latest";
}
