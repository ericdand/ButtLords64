using UnityEngine;
using System.Collections;

public class Waypoint : MonoBehaviour {

	public Transform player;

	internal bool isVisited;

	// Use this for initialization
	void Start () {
		if (player == null) {
			Debug.LogWarning ("Player object of waypoint not set");
		}
	}

	private bool withinEpsilon (Vector3 a, Vector3 b, float e) {
		Debug.Log("dx: " + (a.x - b.x) + "\ndy: " + (a.y - b.y) + "\ndz: " + (a.z + b.z));
		return (Mathf.Abs (a.x - b.x) <= e
		&& Mathf.Abs (a.y - b.y) <= e
		&& Mathf.Abs (a.z - b.z) <= e);
	}

	// Update is called once per frame
	void Update () {
		if (player) {
			var playerWidth = player.GetComponent<BoxCollider2D> ().size.x;
			if (withinEpsilon (player.position, this.transform.position, playerWidth / 2)) {
				isVisited = true;
				Debug.Log ("I AM VISITED!");
			}
		}
	}

	public Vector2 Position() {
		return this.transform.position;
	}
}
