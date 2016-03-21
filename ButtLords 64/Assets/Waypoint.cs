using UnityEngine;
using System.Collections;

public class Waypoint : MonoBehaviour {

	public bool isVisited;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	// TODO: Is making a new Vector2 every time necessary?
	public Vector2 Position() {
		return transform.position;
	}
}
