using UnityEngine;
using System.Collections;

public class PlayerScript : MonoBehaviour {

	// Public so it can be set from the Unity editor.
	public WaypointContainerScript waypointContainer;
	Rigidbody2D rb2d;
	Vector2 acceleration;

	// Use this for initialization
	void Start () {
		rb2d = GetComponent<Rigidbody2D> ();
		acceleration = new Vector2 ();
	}
	
	// Update is called once per frame
	void Update () {
		// Go to the next waypoint.
		var waypoint = waypointContainer.GetNextWaypoint();
		if (waypoint != null) {
			acceleration = (waypoint.Position() - (Vector2)this.transform.position);
			Debug.Log (acceleration);
		}
		rb2d.AddForce(acceleration);
	}
}
