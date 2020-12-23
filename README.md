# nanoc issue repro

`bundle exec nanoc check stale` fails when removing useless `:excerpt` representation of pictures (`output/photos/The_Osborne_Apartments-excerpt.jpeg`).
Everything works as expected in terms of routing and compilation, only check fails.

## Steps to reproduce
```
$ bundle install
$ rm -rf output && bundle exec nanoc && bundle exec nanoc check stale
```

Output:
```
$ rm -rf output && bundle exec nanoc && bundle exec nanoc check stale
Loading site… done
Compiling site…
      create  [0.00s]  output/photos/The_Osborne_Apartments-default.jpeg
      create  [0.00s]  output/photos/WoodStorkWhole-default.jpeg
      create  [0.00s]  output/photos/WoodStorkWhole-excerpt.jpeg
      create  [0.00s]  output/index.html
      create  [0.01s]  output/2020/12/23/test/index.html

Site compiled in 0.23s.
Loading site… done
  Running check stale…   error
Issues found!
  output/photos/WoodStorkWhole-excerpt.jpeg:
    [ ERROR ] stale - file without matching item

Error: One or more checks failed
```

Commenting code related to `all_excerpt_pictures` in preprocess L11-16 and route L66 fixes the issue (but routes pictures not needed (`output/photos/The_Osborne_Apartments-excerpt.jpeg`)).

Output:
```
$ rm -rf output && bundle exec nanoc && bundle exec nanoc check stale
Loading site… done
Compiling site…
      create  [0.00s]  output/photos/The_Osborne_Apartments-excerpt.jpeg
      create  [0.00s]  output/photos/The_Osborne_Apartments-default.jpeg
      create  [0.00s]  output/photos/WoodStorkWhole-excerpt.jpeg
      create  [0.00s]  output/photos/WoodStorkWhole-default.jpeg
      create  [0.00s]  output/index.html
      create  [0.03s]  output/2020/12/23/test/index.html

Site compiled in 0.21s.
Loading site… done
  Running check stale…   ok
```
