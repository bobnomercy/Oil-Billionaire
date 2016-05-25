import interfascia.*;

final int stateButtonWidth = 60;
final int stateButtonHeight = 40;
final int stateButtonGap = 5;
 
GUIController c;
IFButton pump, transport, refinery;
PImage pumpBackground, lowLevelRig1, mediumLevelRig1, highLevelRig1, smallContainer, largeContainer, advancedLevelRig, outrageousLevelRig,
refBackground, lowLevelRef, highLevelRef, fuelContainer,
transBackground, oilShipDock, fuelShipDock, winningBackground;

//Set state to pump to start with
String state = "pump";

//Grid
final int xGridSquares = 8;
final int yGridSquares = 6;
String[][] pumpGrid = new String [yGridSquares][xGridSquares];
final int topLine = 140;
static int gridSquareW;
static int gridSquareH;
HashMap gridSymbols = new HashMap();

//Grid for ref
String[][] refGrid = new String [yGridSquares][xGridSquares];

//purchase system
int xSquareSelected = 0;
int ySquareSelected = 0;
int xSquareSelectedRef = 0;
int ySquareSelectedRef = 0;
boolean pumpMenuActive = false;
boolean refMenuActive = false;
IFButton llr, mlr, hlr, alr, olr, sc, lc, llref, hlref, fc;
final int menuButtonH = 50;
final int menuButtonX = 100;
final int topButtonY = 120;
final int menuButtonW = 300;
HashMap pumpCosts = new HashMap();
HashMap pumpOutputs = new HashMap();
HashMap containerStorages = new HashMap();

IFButton purchaseTile;

//default cash
int money = 100000;

//Oil storage
int maxStorage = 0;
float oilStored = 0;
IFProgressBar oilStorageStatus;
//Fuel storage
int maxFuelStorage = 0;
float fuelStored = 0;
IFProgressBar fuelStorageStatus;

//Transportataion
int transTopLine = 200;
boolean transMenuActive = false;
int xSquareSelectedTrans = 0;
IFButton fs, os;
String transGrid[] = new String [xGridSquares];
int oilPrice = 4;
int fuelPrice = 7;
int fuelShipBoostCost = 300000;
int oilShipBoostCost = 250000;
int fuelShipBoostLevel = 1;
int oilShipBoostLevel = 1;

int finshSeconds = -1;
IFButton fuelShipBoost, oilShipBoost;

void setup() {
  size(640, 480);
  c = new GUIController (this);
  frameRate(61);
  
  oilStorageStatus = new IFProgressBar(300, 20, 100);
  fuelStorageStatus = new IFProgressBar(300, 40, 100);
  c.add(oilStorageStatus);
  c.add(fuelStorageStatus);
  
  fuelShipBoost = new IFButton("Fuel Ship Boost - $300,000", 20, 70, 200);
  oilShipBoost = new IFButton("Oil Ship Boost - $250,000", 240, 70, 200);
  
  fuelShipBoost.addActionListener(this);
  oilShipBoost.addActionListener(this);
  
  c.add(fuelShipBoost);
  c.add(oilShipBoost);
  
  pump = new IFButton("Pump", 20, 20, stateButtonWidth, stateButtonHeight);
  transport = new IFButton("Transport", 20 + stateButtonWidth*2 + stateButtonGap*2, 20, stateButtonWidth, stateButtonHeight);
  refinery = new IFButton("Refinery", 20 + stateButtonWidth + stateButtonGap, 20, stateButtonWidth, stateButtonHeight);
  
  // Setup button event listeners
  pump.addActionListener(this);
  transport.addActionListener(this);
  refinery.addActionListener(this);
  
  
  //load images
  pumpBackground = loadImage("background.png");
  lowLevelRig1 = loadImage("Low Level Rig0001.png");
  mediumLevelRig1 = loadImage("Medium Level Rig0001.png");
  highLevelRig1 = loadImage("High Level Rig0001.png");
  smallContainer = loadImage("Small Oil Container.png");
  largeContainer = loadImage("Large Oil Container.png");
  refBackground = loadImage("backgroundRef.png");
  lowLevelRef = loadImage("Low Level Refinery.png");
  highLevelRef = loadImage("High Level Refinery.png");
  fuelContainer = loadImage("Fuel Container.png");
  transBackground = loadImage("transBackground.png");
  oilShipDock = loadImage("Oil Ship.png");
  fuelShipDock = loadImage("Fuel Ship.png");
  advancedLevelRig = loadImage("Advanced Level Rig0001.png");
  outrageousLevelRig = loadImage("Outrageous Level Rig0001.png");
  winningBackground = loadImage("winnersBackground.png");
  
  //grid stuff
  gridSquareW = width / xGridSquares;
  gridSquareH = (height - topLine) / yGridSquares;
  
  //add symbols to symbol hash map
  gridSymbols.put("a", "Low Level Rig");
  gridSymbols.put("b", "Medium Level Rig");
  gridSymbols.put("c", "High Level Rig");
  gridSymbols.put("d", "Advanced Level Rig");
  gridSymbols.put("e", "Outrageous Level Rig");
  gridSymbols.put("f", "Purchased Tile");
  gridSymbols.put("g", "Unpurchased Tile");
  gridSymbols.put("h", "Small Container");
  gridSymbols.put("i", "Large Container");
  gridSymbols.put("j", "Fuel Container");
  gridSymbols.put("k", "Low Level Refinery");
  gridSymbols.put("l", "High Level Refinery");
  gridSymbols.put("m", "Oil Ship Dock");
  gridSymbols.put("n", "Fuel Ship Dock");
  
  pumpCosts.put("Low Level Rig", 10000);
  pumpCosts.put("Medium Level Rig", 50000);
  pumpCosts.put("High Level Rig", 200000);
  pumpCosts.put("Advanced Level Rig", 800000);
  pumpCosts.put("Outrageous Level Rig", 20000000);
  pumpCosts.put("Tile", 5000);
  pumpCosts.put("Small Container", 7500);
  pumpCosts.put("Large Container", 200000);
  pumpCosts.put("Low Level Refinery", 100000);
  pumpCosts.put("High Level Refinery", 30000000);
  pumpCosts.put("Fuel Container", 80000);
  pumpCosts.put("Oil Ship Dock", 60000);
  pumpCosts.put("Fuel Ship Dock", 100000);
  
  pumpOutputs.put("a", 300);
  pumpOutputs.put("b", 600);
  pumpOutputs.put("c", 1600);
  pumpOutputs.put("d", 4200);
  pumpOutputs.put("e", 12000);
  
  pumpOutputs.put("k", 3000);
  pumpOutputs.put("l", 20000);
  
  pumpOutputs.put("m", 8000);
  pumpOutputs.put("n", 6000);
  
  containerStorages.put("h", 25000);
  containerStorages.put("i", 80000);
  containerStorages.put("j", 60000);
  
  purchaseTile = new IFButton ("Purchase Tile - $" + commafy(int(pumpCosts.get("Tile").toString())), topButtonY, menuButtonX, menuButtonW);
  purchaseTile.addActionListener(this);
  
  fs = new IFButton("Fuel Ship Dock - $" + commafy(int(pumpCosts.get("Fuel Ship Dock").toString())), menuButtonX, topButtonY, menuButtonW);
  os = new IFButton("Oil Ship Dock - $" + commafy(int(pumpCosts.get("Oil Ship Dock").toString())), menuButtonX, topButtonY + menuButtonH, menuButtonW);
  
  fs.addActionListener(this);
  os.addActionListener(this);
  
  c.add(fs);
  c.add(os);
  //purchase menu GUI
  llr = new IFButton("Low Level Rig - $" + commafy(int(pumpCosts.get("Low Level Rig").toString()))+" - "+commafy(int(pumpOutputs.get("a").toString())) + "litres/sec", menuButtonX, topButtonY, menuButtonW);
  mlr = new IFButton("Medium Level Rig - $" + commafy(int(pumpCosts.get("Medium Level Rig").toString()))+" - "+commafy(int(pumpOutputs.get("b").toString())) + "litres/sec", menuButtonX, topButtonY + menuButtonH * 1, menuButtonW);
  hlr = new IFButton("High Level Rig - $" + commafy(int(pumpCosts.get("High Level Rig").toString()))+" - "+commafy(int(pumpOutputs.get("c").toString())) + "litres/sec", menuButtonX, topButtonY + menuButtonH * 2, menuButtonW);
  alr = new IFButton("Advanced Level Rig - $" + commafy(int(pumpCosts.get("Advanced Level Rig").toString()))+" - "+commafy(int(pumpOutputs.get("d").toString())) + "litres/sec", menuButtonX, topButtonY + menuButtonH * 3, menuButtonW);
  olr = new IFButton("Outrageous Level Rig - $" + commafy(int(pumpCosts.get("Outrageous Level Rig").toString()))+" - "+commafy(int(pumpOutputs.get("e").toString())) + "litres/sec", menuButtonX, topButtonY + menuButtonH * 4, menuButtonW);
  sc = new IFButton("Small Container - $" + commafy(int(pumpCosts.get("Small Container").toString()))+" - "+commafy(int(containerStorages.get("h").toString())) + "litres", menuButtonX, topButtonY + menuButtonH * 5, menuButtonW);
  lc = new IFButton("Large Container - $" + commafy(int(pumpCosts.get("Large Container").toString()))+" - "+commafy(int(containerStorages.get("i").toString())) + "litres", menuButtonX, topButtonY + menuButtonH * 6, menuButtonW);
  
  llref = new IFButton("Low Level Refinery - $" + commafy(int(pumpCosts.get("Low Level Refinery").toString())) + " - "+commafy(int(pumpOutputs.get("k").toString())) + "litres/sec", menuButtonX, topButtonY + menuButtonH * 0, menuButtonW);
  hlref = new IFButton("High Level Refinery - $" + commafy(int(pumpCosts.get("High Level Refinery").toString())) + " - "+commafy(int(pumpOutputs.get("l").toString())) + "litres/sec", menuButtonX, topButtonY + menuButtonH * 1, menuButtonW);
  fc = new IFButton("Fuel Container - $" + commafy(int(pumpCosts.get("Fuel Container").toString())) + " - "+commafy(int(containerStorages.get("j").toString())) + "litres", menuButtonX, topButtonY + menuButtonH * 2, menuButtonW);
  
  llr.addActionListener(this);
  mlr.addActionListener(this);
  hlr.addActionListener(this);
  alr.addActionListener(this);
  olr.addActionListener(this);
  sc.addActionListener(this);
  lc.addActionListener(this);
  
  llref.addActionListener(this);
  hlref.addActionListener(this);
  fc.addActionListener(this);
  
  c.add(llr);
  c.add(mlr);
  c.add(hlr);
  c.add(alr);
  c.add(olr);
  c.add(lc);
  c.add(sc);
  
  c.add(llref);
  c.add(hlref);
  c.add(fc);
  
  c.add(purchaseTile);
  
  // Add buttons
  c.add(pump);
  c.add(transport);
  c.add(refinery);
  
  resetTilePurchases();
}

void resetTilePurchases(){
  for (int i = 0; i < yGridSquares; i++){
    for (int j = 0; j < xGridSquares; j++){
      pumpGrid[i][j] = "g";
      refGrid[i][j] = "g";
    }
  }
  for (int i = 0; i < xGridSquares; i++){
    transGrid[i] = "g";
  }
}
String commafy(int uncommaed){
  return String.format("%,d", uncommaed);
}

void draw() {
  switch (state){
    case "pump":
      image(pumpBackground, 0, 0);
      drawGrid();
      purchaseMenu();
      drawAnimatedSprites();
      hidePurchaseMenuRef();
      hidePurchaseMenuTrans();
      hideOilShipBoostTile();
      break;
    case "transport":
      image(transBackground, 0, 0);
      drawTransGrid();
      purchaseMenuTrans();
      hidePurchaseMenu();
      hidePurchaseMenuRef();
      drawAnimatedSpritesTrans();
      showOilShipBoostTile();
      break;
    case "refinery":
      image(refBackground, 0, 0);
      drawGrid();
      purchaseMenuRef();
      hidePurchaseMenuTrans();
      hidePurchaseMenu();
      drawAnimatedSpritesRef();
      hideOilShipBoostTile();
      break;
  }
  textSize(32);
  fill(0, 0, 0, 255);
  text("$" + commafy(money), 400, 20+32);
  updateOilStorage();
  addOil();
  oilStorageStatus.setProgress(oilStored / maxStorage);
  fuelStorageStatus.setProgress(fuelStored / maxFuelStorage);
  textSize(16);
  text((millis()-startingMillis)/1000 + "s", 560, 80);
  textSize(10);
  text("Fuel", 280, 52);
  text("Oil", 285, 33);
  int total=0;
  for(int i = 0; i < 60; i++)total+=fuelProductionRates[i];
  text(commafy(total/60) + " l/s", 215, 52);
  total=0;
  for(int i = 0; i < 60; i++)total+=oilProductionRates[i];
  text(commafy(total/60) + " l/s", 215, 33);
  
  if (money >= 1000000000){
    if (finshSeconds < 0)
      finshSeconds = (millis()-startingMillis) / 1000;
    image(winningBackground, 0, 0);
    textSize(32);
    text("In " + commafy(finshSeconds) + " Seconds", 20, 450);
  }
}
int[] fuelProductionRates = new int[60];
int[] oilProductionRates = new int[60];
int startingMillis = millis();
int lastMillis = millis();
int durMillis = 0;
void addOil(){
  int fuelProductionRate=0;
  int oilProductionRate=0;
  for (int i = 0; i < yGridSquares; i++){
    for (int j = 0; j < xGridSquares; j++){
      if(pumpOutputs.get(refGrid[i][j]) != null){
        if (oilStored - float(pumpOutputs.get(refGrid[i][j]).toString()) >= 0 && float(pumpOutputs.get(refGrid[i][j]).toString()) * (millis() - lastMillis) /1000 + fuelStored <= maxFuelStorage ){
            fuelStored +=  float(pumpOutputs.get(refGrid[i][j]).toString()) * (millis() - lastMillis)/1000;
            oilStored -=  float(pumpOutputs.get(refGrid[i][j]).toString()) * (millis() - lastMillis)/1000;
            fuelProductionRate+=float(pumpOutputs.get(refGrid[i][j]).toString());
          }
        else if (state == "refinery"){
          fill(255, 50, 50, 100);
          noStroke();
          rect(j*gridSquareW + 1, i * gridSquareH + topLine + 1, gridSquareW-1, gridSquareH-1);
          fill(0);
        }
      }
      if(pumpOutputs.get(pumpGrid[i][j]) != null){
        if (float(pumpOutputs.get(pumpGrid[i][j]).toString()) * (millis() - lastMillis) / 1000 + oilStored <= maxStorage){
          oilStored +=  float(pumpOutputs.get(pumpGrid[i][j]).toString()) * (millis() - lastMillis) / 1000;
          oilProductionRate += float(pumpOutputs.get(pumpGrid[i][j]).toString());
        }
        else if (state == "pump"){
          fill(255, 50, 50, 100);
          noStroke();
          rect(j*gridSquareW + 1, i * gridSquareH + topLine + 1, gridSquareW-1, gridSquareH-1);
          fill(0);
        }
      }
    }
  }
  durMillis += millis()-lastMillis;
  if (durMillis > 1000){
    durMillis = 0;
    for (int i = 0; i < xGridSquares; i++){
      if (oilStored - int(pumpOutputs.get("m").toString()) * oilShipBoostLevel >= 0){
        if (transGrid[i] == "m"){
          oilStored -= int(pumpOutputs.get("m").toString()) * oilShipBoostLevel;
          money += oilPrice*int(pumpOutputs.get("m").toString()) * oilShipBoostLevel;
        }
      }
      if (fuelStored - int(pumpOutputs.get("n").toString()) * fuelShipBoostLevel >= 0){
        if (transGrid[i] == "n"){
          fuelStored -= int(pumpOutputs.get("n").toString()) * fuelShipBoostLevel;
          money += fuelPrice*int(pumpOutputs.get("n").toString()) * fuelShipBoostLevel;
        }
      }
    }
  }
  for (int point = 0; point < (60) - 1; point++) {
    oilProductionRates[point] = oilProductionRates[point + 1];
    fuelProductionRates[point] = fuelProductionRates[point + 1];
  }
  oilProductionRates[(60) - 1] = oilProductionRate;
  fuelProductionRates[(60) - 1] = fuelProductionRate;
  
  lastMillis = millis();
}

void updateOilStorage(){
  maxStorage = 0;
  for (int i = 0; i < yGridSquares; i++){
    for (int j = 0; j < xGridSquares; j++){
      if(containerStorages.get(pumpGrid[i][j]) != null){
        maxStorage +=  int(containerStorages.get(pumpGrid[i][j]).toString());
      }
    }
  }
  maxFuelStorage = 0;
  for (int i = 0; i < yGridSquares; i++){
    for (int j = 0; j < xGridSquares; j++){
      if(containerStorages.get(refGrid[i][j]) != null){
        maxFuelStorage +=  int(containerStorages.get(refGrid[i][j]).toString());
      }
    }
  }
}

void mouseClicked(){
  switch (state){
    case "pump":
      if (mouseButton == RIGHT){
        pumpMenuActive = !pumpMenuActive;
        for (int i = 0; i < yGridSquares; i++){
          for (int j = 0; j < xGridSquares; j++){
            if (mouseX > j * gridSquareW && mouseX < (j + 1) * gridSquareW && mouseY > i * gridSquareH + topLine && mouseY < (i + 1) * gridSquareH + topLine){
              xSquareSelected = j;
              ySquareSelected = i;
            }
          }
        }
      }
      break;
    case "refinery":
      if (mouseButton == RIGHT){
        refMenuActive = !refMenuActive;
        for (int i = 0; i < yGridSquares; i++){
          for (int j = 0; j < xGridSquares; j++){
            if (mouseX > j * gridSquareW && mouseX < (j + 1) * gridSquareW && mouseY > i * gridSquareH + topLine && mouseY < (i + 1) * gridSquareH + topLine){
              xSquareSelectedRef = j;
              ySquareSelectedRef = i;
            }
          }
        }
      }
      break;
    case "transport":
      if (mouseButton == RIGHT){
        transMenuActive = !transMenuActive;
        for(int i = 0; i < xGridSquares; i++){
          if (mouseX > i * gridSquareW && mouseX < (i + 1) * gridSquareW && mouseY > transTopLine && mouseY < transTopLine + gridSquareH){
            xSquareSelectedTrans = i;
          }
        }
      }
      break;
  }
}

void hidePurchaseMenu(){
  llr.setX(1000);
  mlr.setX(1000);
  hlr.setX(1000);
  alr.setX(1000);
  olr.setX(1000);
  sc.setX(1000);
  lc.setX(1000);
}
void showPurchaseMenu(){
  llr.setX(menuButtonX);
  mlr.setX(menuButtonX);
  hlr.setX(menuButtonX);
  alr.setX(menuButtonX);
  olr.setX(menuButtonX);
  lc.setX(menuButtonX);
  sc.setX(menuButtonX);
}
void hidePurchaseMenuRef(){
  llref.setX(1000);
  hlref.setX(1000);
  fc.setX(1000);
}
void hidePurchaseMenuTrans(){
  fs.setX(1000);
  os.setX(1000);
}
void showPurchaseMenuRef(){
  llref.setX(menuButtonX);
  hlref.setX(menuButtonX);
  fc.setX(menuButtonX);
}
void showPurchaseMenuTrans(){
  os.setX(menuButtonX);
  fs.setX(menuButtonX);
}
void showPurchaseTile(){
  purchaseTile.setX(menuButtonX);
}

void hidePurchaseTile(){
  purchaseTile.setX(1000);
}

void showOilShipBoostTile(){
  oilShipBoost.setX(240);
  fuelShipBoost.setX(20);
}

void hideOilShipBoostTile(){
  oilShipBoost.setX(1000);
  fuelShipBoost.setX(1000);
}
void shadeSelectedTrans(){
  fill(123, 123, 123, 100);
  rect(xSquareSelectedTrans * gridSquareW, transTopLine, gridSquareW, gridSquareH);
}

void shadeSelected(){
  fill(123, 123, 123, 100);
  rect(xSquareSelected * gridSquareW, ySquareSelected * gridSquareH + topLine, gridSquareW, gridSquareH);
}
void shadeSelectedRef(){
  fill(123, 123, 123, 100);
  rect(xSquareSelectedRef * gridSquareW, ySquareSelectedRef * gridSquareH + topLine, gridSquareW, gridSquareH);
}
void shadePurchased(){
  fill(200, 200, 200, 200);
  for (int i = 0; i < yGridSquares; i++){
    for (int j = 0; j < xGridSquares; j++){
      if(pumpGrid[i][j] == "g"){
        rect(j * gridSquareW, i * gridSquareH + topLine, gridSquareW, gridSquareH);
      }
    }
  }
}
void shadePurchasedRef(){
  fill(200, 200, 200, 200);
  for (int i = 0; i < yGridSquares; i++){
    for (int j = 0; j < xGridSquares; j++){
      if(refGrid[i][j] == "g"){
        rect(j * gridSquareW, i * gridSquareH + topLine, gridSquareW, gridSquareH);
      }
    }
  }
}
void shadePurchasedTrans(){
  fill(200, 200, 200, 200);
  for (int i = 0; i < xGridSquares; i++){
    if(transGrid[i] == "g"){
       rect(i * gridSquareW, transTopLine, gridSquareW, gridSquareH);
    }
  }
}

void drawAnimatedSprites(){
  for (int i = 0; i < yGridSquares; i++){
    for (int j = 0; j < xGridSquares; j++){
      if(pumpGrid[i][j] == "a"){
        image(lowLevelRig1, j*gridSquareW, i*gridSquareH + topLine-40);
      }
      if(pumpGrid[i][j] == "b"){
        image(mediumLevelRig1, j*gridSquareW, i*gridSquareH + topLine-40);
      }
      if(pumpGrid[i][j] == "c"){
        image(highLevelRig1, j*gridSquareW, i*gridSquareH + topLine-40);
      }
      if(pumpGrid[i][j] == "h"){
        image(smallContainer, j*gridSquareW, i*gridSquareH + topLine-40);
      }
      if(pumpGrid[i][j] == "i"){
        image(largeContainer, j*gridSquareW, i*gridSquareH + topLine-40);
      }
      if(pumpGrid[i][j] == "d"){
        image(advancedLevelRig, j*gridSquareW, i*gridSquareH + topLine-40);
      }
      if(pumpGrid[i][j] == "e"){
        image(outrageousLevelRig, j*gridSquareW, i*gridSquareH + topLine-40);
      }
    }
  }
}
void drawAnimatedSpritesRef(){
  for (int i = 0; i < yGridSquares; i++){
    for (int j = 0; j < xGridSquares; j++){
      if(refGrid[i][j] == "j"){
        image(fuelContainer, j*gridSquareW, i*gridSquareH + topLine-40);
      }
      if(refGrid[i][j] == "k"){
        image(lowLevelRef, j*gridSquareW, i*gridSquareH + topLine-40);
      }
      if(refGrid[i][j] == "l"){
        image(highLevelRef, j*gridSquareW, i*gridSquareH + topLine-40);
      }
    }
  }
}

void drawAnimatedSpritesTrans(){
  for (int i = 0; i < xGridSquares; i++){
    if(transGrid[i] == "m"){
      image(oilShipDock, i*gridSquareW, transTopLine);
    }
    if(transGrid[i] == "n"){
      image(fuelShipDock, i*gridSquareW, transTopLine);
    }
  }
}

void purchaseMenuTrans(){
  if (transMenuActive){
    if (transGrid[xSquareSelectedTrans] != "g"){
      showPurchaseMenuTrans();
      hidePurchaseTile();
    }
    else{
      showPurchaseTile();
    }
    shadeSelectedTrans();
  }
  else{
    hidePurchaseTile();
    hidePurchaseMenuTrans();
  }
  shadePurchasedTrans();
}

void purchaseMenu(){
  if (pumpMenuActive){
    if(pumpGrid[ySquareSelected][xSquareSelected] != "g"){
      showPurchaseMenu();
      hidePurchaseTile();
    }
    else{
      showPurchaseTile();
    }
    shadeSelected();
  }
  else{
    hidePurchaseTile();
    hidePurchaseMenu();
  }
  shadePurchased();
}
void purchaseMenuRef(){
  if (refMenuActive){
    if(refGrid[ySquareSelectedRef][xSquareSelectedRef] != "g"){
      showPurchaseMenuRef();
      hidePurchaseTile();
    }
    else{
      showPurchaseTile();
    }
    shadeSelectedRef();
  }
  else{
    hidePurchaseTile();
    hidePurchaseMenuRef();
  }
  shadePurchasedRef();
}

void drawTransGrid(){
  stroke(255);
  for(int i = 0; i < xGridSquares; i++){
    line(i * gridSquareW, transTopLine, i * gridSquareW, transTopLine + gridSquareH);
  }
  line(0, transTopLine, width, transTopLine);
  line(0, transTopLine + gridSquareH, width, transTopLine + gridSquareH);
}

void drawGrid(){
  stroke(255);
  for (int i = 0; i < yGridSquares; i++){
      line(0, i*gridSquareH + topLine, width, i*gridSquareH + topLine);
  }
  for (int i = 0; i < xGridSquares; i++){
      line(i*gridSquareW, topLine, i*gridSquareW, height);
  }
}

void attemptPumpPurchase(String purchase){
  int cost = int(pumpCosts.get(purchase).toString());
  try{
    if(state == "pump"){
      cost -= int(pumpCosts.get(gridSymbols.get(pumpGrid[ySquareSelected][xSquareSelected])).toString());
    }
    else if(state == "refinery"){
      cost -= int(pumpCosts.get(gridSymbols.get(refGrid[ySquareSelectedRef][xSquareSelectedRef])).toString());
    }
    else{
      cost -= int(pumpCosts.get(gridSymbols.get(transGrid[xSquareSelectedTrans])).toString());
    }
  }
  finally{
    if(cost <= money){
      money -= cost;
      switch (purchase){
        case "Low Level Rig":
          pumpGrid[ySquareSelected][xSquareSelected] = "a";
          break;
        case "Medium Level Rig":
          pumpGrid[ySquareSelected][xSquareSelected] = "b";
          break;
        case "High Level Rig":
          pumpGrid[ySquareSelected][xSquareSelected] = "c";
          break;
        case "Advanced Level Rig":
          pumpGrid[ySquareSelected][xSquareSelected] = "d";
          break;
        case "Outrageous Level Rig":
          pumpGrid[ySquareSelected][xSquareSelected] = "e";
          break;
        case "Small Container":
          pumpGrid[ySquareSelected][xSquareSelected] = "h";
          break;
        case "Large Container":
          pumpGrid[ySquareSelected][xSquareSelected] = "i";
          break;
        case "Fuel Container":
          refGrid[ySquareSelectedRef][xSquareSelectedRef] = "j";
          break;
        case "Low Level Refinery":
          refGrid[ySquareSelectedRef][xSquareSelectedRef] = "k";
          break;
        case "High Level Refinery":
          refGrid[ySquareSelectedRef][xSquareSelectedRef] = "l";
          break;
        case "Oil Ship Dock":
          transGrid[xSquareSelectedTrans] = "m";
          break;
        case "Fuel Ship Dock":
          transGrid[xSquareSelectedTrans] = "n";
          break;
        case "Tile":
          hidePurchaseTile();
          if (state == "pump")
            pumpGrid[ySquareSelected][xSquareSelected] = "f";
          else if (state == "refinery")
            refGrid[ySquareSelectedRef][xSquareSelectedRef] = "f";
          else if (state == "transport")
            transGrid[xSquareSelectedTrans] = "f";
          break;
      }
    }
  }
}

void actionPerformed (GUIEvent e){
  if (e.getSource() == pump){
     state = "pump";
  }
  else if (e.getSource() == transport){
     state = "transport";
  }
  else if (e.getSource() == refinery){
     state = "refinery";
  }
  else if (e.getSource() == purchaseTile){
    attemptPumpPurchase("Tile");
  }
  else if (e.getSource() == llr){
    attemptPumpPurchase("Low Level Rig");
  }
  else if (e.getSource() == mlr){
    attemptPumpPurchase("Medium Level Rig");
  }
  else if (e.getSource() == hlr){
    attemptPumpPurchase("High Level Rig");
  }
  else if (e.getSource() == alr){
    attemptPumpPurchase("Advanced Level Rig");
  }
  else if (e.getSource() == olr){
    attemptPumpPurchase("Outrageous Level Rig");
  }
  else if (e.getSource() == sc){
    attemptPumpPurchase("Small Container");
  }
  else if (e.getSource() == lc){
    attemptPumpPurchase("Large Container");
  }
  else if (e.getSource() == llref){
    attemptPumpPurchase("Low Level Refinery");
  }
  else if (e.getSource() == hlref){
    attemptPumpPurchase("High Level Refinery");
  }
  else if (e.getSource() == fc){
    attemptPumpPurchase("Fuel Container");
  }
  else if (e.getSource() == fs){
    attemptPumpPurchase("Fuel Ship Dock");
  }
  else if (e.getSource() == os){
    attemptPumpPurchase("Oil Ship Dock");
  }
  else if (e.getSource() == fuelShipBoost){
    if (money - fuelShipBoostCost >= 0){
      money -= fuelShipBoostCost;
      fuelShipBoostLevel += 1;
      fuelShipBoostCost = fuelShipBoostLevel*250000;
      fuelShipBoost.setLabel("Fuel Ship Boost - $"+commafy(fuelShipBoostCost));
    }
  }
  else if (e.getSource() == oilShipBoost){
    if (money - oilShipBoostCost >= 0){
      money -= oilShipBoostCost;
      oilShipBoostLevel += 1;
      oilShipBoostCost = oilShipBoostLevel*250000;
      oilShipBoost.setLabel("Oil Ship Boost - $"+commafy(oilShipBoostCost));
    }
  }
}