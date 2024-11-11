class Song {
  final String title;
  final String? artist;
  final String uri;
  final String? imageUrl;

  Song({
    required this.imageUrl,
    required this.title,
    required this.artist,
    required this.uri,
  });
}

List<Song> popularSongs = [
  Song(
    imageUrl:
        "https://images.genius.com/95cfea0187b37c7731e11d54b07d2415.1000x1000x1.png",
    title: "Not like us",
    artist: "Kendrick Lamar",
    uri:
        "https://p.scdn.co/mp3-preview/0beafd37eaa57bed9998750406ca8c7e3a3bff5a?cid=cfe923b2d660439caf2b557b21f31221",
  ),
  Song(
    imageUrl:
        "https://www.billboard.com/wp-content/uploads/2024/04/Tommy-Richman-cr-Alf-Bordallo-press-2024-billboard-1548.jpg",
    title: "Million dollar baby",
    artist: "Tommy Richman",
    uri:
        "https://p.scdn.co/mp3-preview/e722f5a3f801a2930bfd6cbd5fbcf2bc00e101f2?cid=cfe923b2d660439caf2b557b21f31221",
  ),
  Song(
    imageUrl:
        "https://i1.sndcdn.com/artworks-70ELnRww8DznEFYq-o6xlFQ-t500x500.jpg",
    title: "A bar song",
    artist: "Shaboozey",
    uri:
        "https://p.scdn.co/mp3-preview/7935b8b6750c20d02382b3dda64c2bc39b1d71e5?cid=cfe923b2d660439caf2b557b21f31221",
  ),
  Song(
    imageUrl:
        "https://i1.sndcdn.com/artworks-ycpcO77e5r7x5zwN-3zUn0w-t500x500.jpg",
    title: "Lose control",
    artist: "Teddy Swims",
    uri:
        "https://p.scdn.co/mp3-preview/51e51cc257e4186893b1923abf42fdaabbeeda37?cid=cfe923b2d660439caf2b557b21f31221",
  ),
];

List<Song> recommendedSongs = [
  Song(
    imageUrl:
        "https://i.scdn.co/image/ab67616d0000b273b0dd6a5cd1dec96c4119c262",
    title: "One of the girls",
    artist: "The Weekend",
    uri:
        "https://p.scdn.co/mp3-preview/5cf2d2ba1f2011fe7d1c3af290cdd4c1e17c26e9?cid=cfe923b2d660439caf2b557b21f31221",
  ),
  Song(
    imageUrl:
        "https://images.genius.com/582fc80810f34013e4a1864e009cf7e3.1000x1000x1.png",
    title: "Better me",
    artist: "R3hab",
    uri:
        "https://p.scdn.co/mp3-preview/16e802bd7181a179203f7ed36d1a31546a5e2333?cid=cfe923b2d660439caf2b557b21f31221",
  ),
  Song(
    imageUrl: "https://i1.sndcdn.com/artworks-QzvO3g0V6hcv-0-t500x500.jpg",
    title: "Slow it down",
    artist: "Benson Boone",
    uri:
        "https://p.scdn.co/mp3-preview/7ed92ba5dc69c703af94b4973bb7eecb3fa3cce1?cid=cfe923b2d660439caf2b557b21f31221",
  ),
  Song(
    imageUrl:
        "https://ih1.redbubble.net/image.5499711917.9815/flat,750x,075,f-pad,750x1000,f8f8f8.jpg",
    title: "Good luck",
    artist: "Chappell Roan",
    uri:
        "https://p.scdn.co/mp3-preview/11e88461df92cbf550b86bb0c04a8566ca954490?cid=cfe923b2d660439caf2b557b21f31221",
  ),
  Song(
    imageUrl:
        "https://www.rollingstone.com/wp-content/uploads/2024/05/morgan-wallen-post-malone-song.jpg",
    title: "I had some Help",
    artist: "Post Malone",
    uri:
        "https://p.scdn.co/mp3-preview/25e8ce8eb09d631705ca5f38c16497312b5f5773?cid=cfe923b2d660439caf2b557b21f31221",
  ),
  Song(
    imageUrl:
        "https://i1.sndcdn.com/artworks-NEZMaLB220C3JyBR-GYuAlQ-t500x500.jpg",
    title: "Cynical",
    artist: "Safri Duo",
    uri:
        "https://p.scdn.co/mp3-preview/1cc552fda596586fb5e92593d015eb99968198a9?cid=cfe923b2d660439caf2b557b21f31221",
  ),
];
