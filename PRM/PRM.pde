//.5m character
//20mx20m room (20x20 1m links)
//1m = 10px


int AGENT_RAD = 5;
int START_X_POS = 400;
int START_Y_POS = 600;
int GOAL_X_POS = 600;
int GOAL_Y_POS = 400;
int NODE_ID = 0;
int SAMPLE_SIZE = 8;
int TEST_BUMP = 1;

Agent agent;
Graph graph;

Obstacle[] obstacles = new Obstacle[1];

void sampleObstacles() {
  for (Obstacle o: obstacles) {
    float angle = 0;
    for (int i = 0; i < SAMPLE_SIZE ; i++) { //since its one circle, sample 16 points around it
      float x = (o.radius*TEST_BUMP + agent.radius) * cos(angle);
      float y = (o.radius*TEST_BUMP + agent.radius) * sin(angle);
 
      graph.addNode(NODE_ID, o.xPos + x, o.yPos + y);
      
      angle += radians(360/SAMPLE_SIZE);
    }
  }
}

void setup() {
  agent = new Agent(400,600,AGENT_RAD);
  graph = new Graph();
  
  size(1000,1000);
  background(255);
  
  obstacles[0] = new Obstacle(500,500,20);
  
  graph.setStart(NODE_ID, START_X_POS, START_Y_POS);
  sampleObstacles();
  graph.setGoal(NODE_ID, GOAL_X_POS, GOAL_Y_POS);
  graph.link();
  graph.listNodes();
}

void draw() {
  
  //show grid boundaries
  line(400,400,400,600); //right
  line(400,600,600,600); //bottom
  line(600,600,600,400); //left
  line(600,400,400,400); //top
  
  graph.render();
  agent.render();
  obstacles[0].render();
  
}
