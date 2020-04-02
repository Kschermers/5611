int AGENT_RAD = 15;
int BOIDS_RAD = 40;
int AGENT_COUNT = 10;
int OBS_COUNT = 40;

int START_X_POS = 100;
int START_Y_POS = 200;

int GOAL_X_POS = 900;
int GOAL_Y_POS = 800;

int NODE_ID = 0;
int SAMPLE_SIZE = 16;
float TEST_BUMP = 2;

Agent[] agents;
Graph graph;
Boids boids;

Obstacle[] obstacles = new Obstacle[OBS_COUNT];

void randomizeObstacles() {
  
  int OBS_X_BOT = 150;
  int OBS_X_TOP = 200;
 
  for(int i = 0; i < OBS_COUNT; i++) {
    Obstacle o = new Obstacle(random(OBS_X_BOT,OBS_X_TOP),random(100,900),floor(random(10,40)));
    obstacles[i] = o;
    OBS_X_BOT += 600/OBS_COUNT;
    OBS_X_TOP += 600/OBS_COUNT;
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

int moveAgent(Agent a) {
  
  Node base = graph.graph.get(a.path.get(a.pc));
  //a.path.remove(a.pc);
  Node end = graph.graph.get(a.path.get(a.pc+1));
  
  for (Link l : base.links) {
    if (l.endID == end.id) l.hasAgent = true;
  }
  
  float x = end.xPos - a.xPos;
  float y = end.yPos - a.yPos;
  float len = sqrt(x*x + y*y);
  
  float lerpX = (end.xPos - a.xPos) / (len); 
  float lerpY = (end.yPos - a.yPos) / (len);
  a.updateVel(lerpX,lerpY);
  boids.boids(a);
  a.updatePos();
  
  if (end.id != a.goalID) {
    if (a.atMS(end.xPos, end.yPos)) {
      a.pc++;
      a.giveBounce = false;
      println("Agent: " + a.startID + " at MS: " + end.id + " | x: " + end.xPos + " | y: " + end.yPos);
      return 0;
    }
  } else {
    if (a.atMS(end.xPos, end.yPos)) {
      a.atGoal = true;
      println("Agent: " + a.startID + " at goal!!!");
      return 1;
    }
  }
  return 0;
}

void setup() {
  
  size(1000,1000);
  
  agents = new Agent[AGENT_COUNT];
  graph = new Graph();
  boids = new Boids();
  
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
    for (Node n: graph.graph) {
      n.pathParent = -1;
    }
    agents[i].print();
    println("path: " + agents[i].path.toString());
  }
  
  for(Agent a: agents) {
    if (a.path.get(0) == -1) {
      println("no path found for agent " + a.startID);
      a.path = new ArrayList<Integer>();
      a.path.add(a.startID);
      a.path.add(a.startID);
      a.goalID = a.startID;
    }
  }
  
  //graph.listNodes();
  println("done pre-processing, drawing...");
}

void draw() {
  
  background(0);
  graph.render();
  renderObstacles();
  int goals = 0;
  for (int i = 0; i < AGENT_COUNT; i++) {
    agents[i].render();
    if (!agents[i].atGoal) {
      moveAgent(agents[i]);
      //agents[i].print();
    } else {
      goals++;
    }
  }
  if (goals == AGENT_COUNT) {
    //exit();
  }
}
