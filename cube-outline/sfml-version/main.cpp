/*
  Perspecive Projection chapter. Draw a cube outline.
  Use Vertex Array to draw points.

  This is harder than I thought. I need to create lines, then add them together
  into the vertex array. Will need drawline function from first chapter.

 */

#include <SFML/Graphics.hpp>

using namespace sf;

int main()
{
  RenderWindow window(VideoMode(800, 600), "Cube Outline");

  // try drawing a line with points
  VertexArray points(Points);

  for (int i = 100, j = 100; i < 200; i++, j+=3)
    {
      float x = (float)i;
      float y = (float)j;
      
      points.append(Vertex(Vector2f(x,y), Color::Green));
    }

  /* 
  // Leaving this in for now just to show how it works.
  Vertex v1(Vector2f(150.f,150.f),Color::Red);
  Vertex v2(Vector2f(155.f,155.f), Color::Blue);
  Vertex v3(Vector2f(160.f,160.f), Color::Green);

  points.append(v1);
  points.append(v2);
  points.append(v3);
  */
  
  while (window.isOpen())
    {
      // check for input
      Event event;

      while (window.pollEvent(event))
	{
	  if (event.type == Event::Closed)
	    window.close();
	  
	  else if (event.type == Event::KeyPressed)
	    {
	      if (Keyboard::isKeyPressed(Keyboard::Escape))
		window.close();
	    }
	  
	} // end check for input

      // drawing

      window.clear(Color::Black);

      window.draw(points);
      
      window.display();
    } // end main while loop

  return 0;
}

void addLine(VertexArray va, Vector2f start, Vector2f end, Color color)
{
  // Need to create a drawline function with interpolate, from first section,
  // then add it to the vertex array.
  // Maybe add each line to the vertex array in main, so this function
  // may not be needed.
}
