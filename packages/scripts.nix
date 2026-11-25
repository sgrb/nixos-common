# Пакеты для скриптов из ./scripts.
#
# Каждый скрипт оборачивается так, что явные runtimeInputs идут в PATH
# первыми (скрипт всегда использует именно их), а исходный PATH окружения
# сохраняется следом — иначе внутри запущенной песочницы (pi) не будет
# привычных пользовательских утилит.
#
# Файл — overlay: `import ./scripts.nix { inherit lib; }` даёт final: prev: {...}
{ lib }:
final: prev:
let
  # file — путь к скрипту в репозитории; первая строка (shebang) отбрасывается,
  # потому что интерпретатор задаёт writeShellScriptBin.
  wrapScript = { name, file, runtimeInputs }:
    prev.writeShellScriptBin name ''
      export PATH="${lib.makeBinPath runtimeInputs}:$PATH"
      ${lib.concatStringsSep "\n" (lib.lists.drop 1 (lib.strings.splitString "\n" (builtins.readFile file)))}
    '';

  baseTools = with prev; [ coreutils bash ];
in
{
  bump-nixpkgs = wrapScript {
    name = "bump-nixpkgs";
    file = ./scripts/bump-nixpkgs;
    runtimeInputs = [ prev.nix prev.jq ] ++ baseTools;
  };

  mpi = wrapScript {
    name = "mpi";
    file = ./scripts/mpi;
    runtimeInputs = with prev; [ bubblewrap nono pi-coding-agent nodejs ] ++ baseTools;
  };
}
