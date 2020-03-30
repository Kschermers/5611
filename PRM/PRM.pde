int AGENT_RAD = 5;
int AGENT_COUNT = 5;
int OBS_COUNT = 60;

int START_X_POS = 100;
int START_Y_POS = 200;

int GOAL_X_POS = 900;
int GOAL_Y_POS = 800;

int NODE_ID = 0;
int SAMPLE_SIZE = 4;
float TEST_BUMP = 2;
int CURRENT_MS = 0;

float STEP_SIZE = 0.005;

Agent[] agents;
Graph graph;

Obstacle[] obstacles = new Obstacle[OBS_COUNT];

void randomizeObstacles() {
 
  for(int i = 0; i < OBS_COUNT; i++) {
    Obstacle o = new Obstacle(random(150,850),random(250,850),floor(random(10,40)));
    obstacles[i] = o;
  }
}
  
void sampleObstacles() {
  for (Obstacle o: obstacles) {
    float angle = 0;
    for (int i = 0; i < SAMPLE_SIZE ; i++) {
      float x = (o.radius + AGENT_RAD*TEST_BUMP) * cos(angle);
      float y = (o.radius + AGENT_RAD*TEST_BUMP) * sin(angle);
 
      graph.addNode(NODE_ID, o.xPos + x, o.yPos + y);
      
      angle += radians(360/SAMPLE_SIZE);
    }
  }
}

void renderObstacles() {
  for (Obstacle o: obstacles) {
    o.render();
  }
}

void moveAgent(Agent a) {
  
  Node base = graph.graph.get(a.path.get(a.pc));
  Node end = graph.graph.get(a.path.get(a.pc+1));
  
  for (Link l : base.links) {
    if (l.endID == end.id) l.hasAgent = true;
  }
  
  float x = end.xPos - base.xPos;
  float y = end.yPos - base.yPos;
  float len = sqrt(x*x + y*y);
  
  float lerpX = (end.xPos - base.xPos) / (len); 
  float lerpY = (end.yPos - base.yPos) / (len);
  a.move(lerpX,lerpY);
  
  if (end.id != a.goalID) {
    if (a.atMS(end.xPos, end.yPos)) {
      a.pc++;
      //println("Agent w/ sID: " + a.startID + " at MS: " + end.id + " | x: " + end.xPos + " | y: " + end.yPos);
    }
  } else {
    if (a.atMS(end.xPos, end.yPos)) {
      a.atGoal = true;
      //println("Agent w/ sID: " + a.startID + " at goal!!!");
    }
  }
}

void setup() {
  
  size(1000,1000);
  
  agents = new Agent[AGENT_COUNT];
  graph = new Graph();
  
  for (int i = 0; i < AGENT_COUNT; i++) {
    agents[i] = new Agent(START_X_POS,START_Y_POS,AGENT_RAD,NODE_ID);
    graph.addAgentStart(NODE_ID, START_X_POS, START_Y_POS);
    
    START_Y_POS += (1000-200)/AGENT_COUNT;
    //START_X_POS += 10;
  }
  
  randomizeObstacles();
  sampleObstacles();
  
  for (int i = 0; i < AGENT_COUNT; i++) {
    agents[i].setGoalID(NODE_ID);
    graph.addAgentGoal(NODE_ID, GOAL_X_POS, GOAL_Y_POS);
    
    GOAL_Y_POS -= (1000-200)/AGENT_COUNT;
    //GOAL_X_POS -= 10;
  }

  graph.link();
  
  for(int i = 0; i < AGENT_COUNT; i++) {
    graph.findPath(agents[i]);
    agents[i].path = graph.buildPath(agents[i]);
    agents[i].print();
    println("path: " + agents[i].path.toString());
  }
  
  //graph.listNodes();
  println("done pre-processing, drawing...");
}

void draw() {
  
  background(0);
  graph.render();
  renderObstacles();
  for (int i = 0; i < AGENT_COUNT; i++) {
    agents[i].render();
    if (!agents[i].atGoal) {
      moveAgent(agents[i]);
      moveAgent(agents[i]);
      //agents[i].print();
    }
  }
}
