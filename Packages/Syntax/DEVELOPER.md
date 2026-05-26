# Integrating a Tree-Sitter Parser into CotEditor

The maintainer of CotEditor, very understandably, does not accept pull requests for new tree-sitter-based syntaxes "because of the maintenance cost". If you still want syntax highlighting for a favorite obscure language, you'll have to fork and roll your own.

If nobody has already written a tree-sitter parser for your language, you'll have to head to https://tree-sitter.github.io/tree-sitter/ and learn how to write one first.

## Add the Package to Xcode Project

In Xcode, use File > Add Package Dependencies... to locate and add the tree-sitter package. We will use https://github.com/nwhetsell/tree-sitter-lilypond as an example.

## Define the Language

In `CotEditor/Resources/Syntaxes/LilyPond.cotsyntax/Info.json`, define the language by adding:

```json
{
  "fileMap" : {
    "extensions" : [
      "ly"
    ]
  },
  "kind" : "code",
  "metadata" : {
    "author" : "shuang886",
    "distributionURL" : "https://coteditor.com",
    "lastModified" : "2026-04-27",
    "license" : "Same as CotEditor",
    "version" : "1.0.0"
  }
}
```

Don't worry about `CotEditor/Resources/SyntaxMap.json` because that will be generated during a build.

In `Packages/Syntax/Sources/SyntaxParsers/TreeSitter/TreeSitterSyntax.swift`:

```diff
+ import TreeSitterLilyPond

  public enum TreeSitterSyntax: String, CaseIterable, Sendable {
    [...]
    case latex = "LaTeX"
+   case lilypond = "LilyPond"
    case lua = "Lua"

    var language: OpaquePointer {
        
        switch self {
            [...]
            case .latex: unsafe tree_sitter_latex()
+           case .lilypond: unsafe tree_sitter_lilypond()
            case .lua: unsafe tree_sitter_lua()
```

## Map Tree-Sitter Output to CotEditor Categories

Inside the tree-sitter package, you may find a `queries/highlights` to serve as a starting point. It may look something like this:

```
(comment) @comments

(punctuation) @attributes

(
  (assignment_lhs) @variables
  .
  (
    (punctuation) @keywords
    (#match? @keywords "^=$")
  )
)
[...etc...]
```

Copy that into `Packages/Syntax/Sources/SyntaxParsers/Queries/LilyPond/highlights.scm`.

Chances are the `highlights.scm` file will produce categories that are not supported by CotEditor. Those should be changed to one of the supported categories ("@values", "@variables", "@keywords", "@attributes", "@numbers", "@comments", "@strings", "@types", "@characters", and "@commands") in order to pass unit tests.

## Unit Test

Add a sample file `Packages/Syntax/Tests/SyntaxParsersTests/Samples/test.ly`, and refer to it in `Packages/Syntax/Tests/SyntaxParsersTests/TreeSitter/TreeSitterSampleHighlightTests.swift`:

```diff
    private func sampleFilename(for syntax: TreeSitterSyntax) -> String {

        switch syntax {
            [...]
            case .latex: "test.tex"
+           case .lilypond: "test.ly"
            case .lua: "test.lua"
```

## To-Do

Figure out how to extract outlines for the newly-added language.
