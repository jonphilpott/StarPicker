
ArrayList<File> fileList;
File destinationFolder;
boolean fileListComplete = false;
PImage currentImage;
PImage section;
int fileNumber = 0;
int sectionNumber = 0;

int WINDOW_SIZE = 20;

void setup() {
  size(1024, 768);
  selectFolder("Select a folder of star images:", "folderSelected");  
}

void showImage(File file) {
  currentImage = loadImage(file.getAbsolutePath());
  image(currentImage, 0, 0);
}

void draw() {
  if (fileListComplete && currentImage == null && fileList.size() > 0) {
    showImage(fileList.get(0));
  }

  if (currentImage != null) {
    section = currentImage.get(mouseX-(WINDOW_SIZE/2), mouseY-(WINDOW_SIZE/2), WINDOW_SIZE, WINDOW_SIZE);
    pushMatrix();
    scale(10);
    image(section, 80, 0);
    popMatrix();
 }
}

void keyPressed() {
  if (keyCode == LEFT) {
    fileNumber--;
  }
  if (keyCode == RIGHT) {
    fileNumber++;
  }
  
  showImage(fileList.get(fileNumber % fileList.size()));
}

void mousePressed() {
  if (section != null) {
    String fileName = destinationFolder.getAbsolutePath() + File.separator + sectionNumber + "_" + fileNumber + "_" +mouseX+"_"+mouseY+".png";
    println("Saving to: " + fileName);
    section.save(fileName);
    sectionNumber++;
    rect(mouseX-(WINDOW_SIZE/2), mouseY-(WINDOW_SIZE/2), WINDOW_SIZE, WINDOW_SIZE);
  }
}

void destinationFolderSelected(File selection) {
  destinationFolder = selection;
}

void folderSelected(File selection) {
  if (selection == null) {
    println("feck.");
  }
  else {
    println("User selected " + selection.getAbsolutePath());
    fileList = new ArrayList<File>();
    buildFileList(selection, fileList);
    
    for (File f: fileList) {
      println("name: " + f.getName());
      println("path: " + f.getAbsolutePath());
    }
    fileListComplete = true;
    selectFolder("Select Output Folder:", "destinationFolderSelected");  
  }
}

void buildFileList(File folder, ArrayList<File> list)  {
  println("scanning: " + folder.getName());
  if (folder.isDirectory()) {
    File[] sub = folder.listFiles();
    for (int i = 0; i < sub.length ; i++) {
      buildFileList(sub[i], list);
    }
  }
  else {
    if (folder.getName().matches(".+png$")) {
      println("-- adding file: " + folder.getName());
      list.add(folder);
    }
  }
}