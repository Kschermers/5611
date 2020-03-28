//.5m character
//20mx20m room (20x20 1m links)
//1m = 10px


int AGENT_RAD = 5;
int OBS_COUNT = 40;

int START_ID = 0;
int START_X_POS = 200;
int START_Y_POS = 800;

int GOAL_ID = -1;
int GOAL_X_POS = 800;
int GOAL_Y_POS = 200;

int NODE_ID = 0;
int SAMPLE_SIZE = 4;
float TEST_BUMP = 2;
int CURRENT_MS = 0;

float STEP_SIZE = 0.005;

ArrayList<Integer> Path = new ArrayList<Integer>();

Agent agent;
Graph graph;

Obstacle[] obstacles = new Obstacle[OBS_COUNT];

void randomizeObstacles() {
 
  for(int i = 0; i < OBS_COUNT; i++) {
    Obstacle o = new Obstacle(random(250,750),random(250,750),floor(random(10,40)));
    obstacles[i] = o;
  }
}
  
void sampleObstacles() {
  for (Obstacle o: obstacles) {
    float angle = 0;
    for (int i = 0; i < SAMPLE_SIZE ; i++) {
      float x = (o.radius + agent.radius*TEST_BUMP) * cos(angle);
      float y = (o.radius + agent.radius*TEST_BUMP) * sin(angle);
 
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

void moveAgent() {
  
  Node base = graph.graph.get(Path.get(CURRENT_MS));
  Node end = graph.graph.get(Path.get(CURRENT_MS+1));
  for (Link l : base.links) {
    if (l.endID == end.id) l.hasAgent = true;
  }
  
  float lerpX = (end.xPos - base.xPos) * STEP_SIZE; 
  float lerpY = (end.yPos - base.yPos) * STEP_SIZE;
  agent.move(lerpX,lerpY);
  
  if (!end.isGoal) {
    if (agent.atMS(end.xPos, end.yPos)) {
      println("at MS: " + end.id + " | x: " + end.xPos + " | y: " + end.yPos);
      //agent.set(base.xPos,base.yPos);
      CURRENT_MS++;
    }
  } else {
    if (agent.atMS(end.xPos, end.yPos)) {
      //agent.set(base.xPos,base.yPos);
      agent.atGoal = true;
      println("at goal!!!");
    }
  }
}

void setup() {
  agent = new Agent(START_X_POS,START_Y_POS,AGENT_RAD);
  graph = new Graph();
  
  size(1000,1000);
  
  randomizeObstacles();
  
  graph.setStart(NODE_ID, START_X_POS, START_Y_POS);
  sampleObstacles();
  println("Goal ID: " + NODE_ID);
  graph.setGoal(NODE_ID, GOAL_X_POS, GOAL_Y_POS);
  graph.link();
  graph.findPath();
  graph.listNodes();
  graph.buildPath();
  Collections.reverse(Path);
  println(Path.toString());
  
  /*graph.render();
  obstacles[0].render();
  obstacles[1].render();
  agent.render();*/
  
}

void draw() {
  
  background(0);
  graph.render();
  renderObstacles();
  agent.render();
  if (!agent.atGoal) moveAgent();
}
